import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gis_dashboard/core/common/widgets/header_title_icon_filter_widget.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_coords_response.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_coverage_visualizer_card_widget.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_tile_layer.dart';
import 'package:gis_dashboard/features/map/presentation/widget/static_compass_direction_indicator_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../domain/area_polygon.dart';
import '../../utils/map_utils.dart';
import '../../utils/map_enums.dart';
import '../controllers/map_controller.dart';
import '../../../epi_center/presentation/screen/epi_center_details_screen.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final mapController = MapController();
  Timer? _autoZoomTimer;
  DateTime? _lastAutoZoom;
  final double _initialZoom = 6.6;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // 🛡️ SAFETY CHECK: Ensure EPI context is cleared when map screen initializes
      // This handles edge cases like navigation stack resets, app state restoration, etc.
      final filterState = ref.read(filterControllerProvider);
      if (filterState.isEpiDetailsContext) {
        logg.w(
          "🚨 Map: EPI context still active when initializing map screen - clearing it",
        );
        ref.read(filterControllerProvider.notifier).clearEpiDetailsContext();
      }

      ref.read(mapControllerProvider.notifier).loadInitialData();
      // Dynamic sync service is now initialized through Riverpod providers
      // No manual initialization needed - uses live FilterController state
    });
  }

  /// Auto-zoom to fit all polygons with padding - now uses centralized function
  void _autoZoomToPolygons(List<AreaPolygon> areaPolygons) {
    final mapState = ref.read(mapControllerProvider);
    autoZoomToPolygons(areaPolygons, mapState.currentLevel, mapController);
  }

  void _resetToCountryView({required GeographicLevel currentLevel}) {
    // Reset to country level first
    if (currentLevel != GeographicLevel.country) {
      ref.read(mapControllerProvider.notifier).resetToCountryLevel();
    }

    // Reset map view to initial position and zoom
    mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
  }

  void _centerViewForCurrentLevelPolygonMap({
    required GeographicLevel currentLevel,
  }) {
    final mapState = ref.read(mapControllerProvider);

    // Parse current polygons to get the bounds
    List<AreaPolygon> currentPolygons = [];
    if (mapState.areaCoordsGeoJsonData != null &&
        mapState.coverageData != null) {
      final filterState = ref.read(filterControllerProvider);
      currentPolygons = parseGeoJsonToPolygons(
        mapState.areaCoordsGeoJsonData!,
        mapState.coverageData!,
        filterState.selectedVaccine,
        currentLevel.value, // Convert enum to string for the parser
      );
    }

    if (currentPolygons.isEmpty) {
      logg.w(
        "No polygons available to center view for level: ${currentLevel.value}",
      );
      return;
    }

    // Use centralized function to calculate center and zoom
    final centerInfo = calculateCurrentLevelCenterAndZoom(
      currentPolygons,
      currentLevel,
    );

    logg.i(
      "Centering view for ${currentLevel.value}: center=${centerInfo.center.latitude}, ${centerInfo.center.longitude}, zoom=${centerInfo.zoom}",
    );

    // Move map to calculated center with appropriate zoom
    mapController.moveAndRotate(centerInfo.center, centerInfo.zoom, 0);
  }

  /// Handle polygon tap for drilldown and filter sync
  void _onPolygonTap(LatLng tappedPoint, List<AreaPolygon> areaPolygons) {
    logg.i("Map tapped at: ${tappedPoint.latitude}, ${tappedPoint.longitude}");

    // Find which polygon was tapped
    AreaPolygon? tappedPolygon;
    for (final areaPolygon in areaPolygons) {
      if (isTappedPointInPolygon(tappedPoint, areaPolygon.polygon.points)) {
        tappedPolygon = areaPolygon;
        break;
      }
    }

    if (tappedPolygon != null) {
      logUidInfo(
        source: "Map Interaction (Polygon Tap)",
        layer: "Map Interaction",
        name: tappedPolygon.areaName,
        uid: tappedPolygon.areaId,
        parentUid: tappedPolygon.parentSlug,
      );
      logg.i("Tapped on: ${tappedPolygon.areaName}");

      final mapState = ref.read(mapControllerProvider);
      final filterState = ref.read(filterControllerProvider);

      // Check if this is a city corporation ward tap
      // FIX: Accept BOTH zone AND cityCorporation levels to handle both:
      // 1. Manual drilldown (currentLevel = zone)
      // 2. Filter-triggered reload after EPI return (currentLevel = cityCorporation)
      // Also validate polygon level for extra safety
      if (((mapState.currentLevel == GeographicLevel.zone ||
                  mapState.currentLevel == GeographicLevel.cityCorporation) &&
              (tappedPolygon.level == GeographicLevel.zone.value ||
                  tappedPolygon.level == 'ward')) &&
          tappedPolygon.orgUid != null &&
          tappedPolygon.orgUid!.isNotEmpty &&
          filterState.selectedAreaType == AreaType.cityCorporation) {
        logg.i(
          "🎯 CC Ward detected: level=${tappedPolygon.level}, mapLevel=${mapState.currentLevel.value}, orgUid=${tappedPolygon.orgUid}",
        );
        _handleCityCorporationWardTapForEpiNavigation(tappedPolygon);
        return;
      }

      // Check if this is a district ward (subblock) - if so, find EPI center and navigate directly
      if (tappedPolygon.level == GeographicLevel.ward.value &&
          tappedPolygon.canDrillDown == false) {
        _handleSubblockTapForEpiNavigation(tappedPolygon);
        return;
      }

      // IMPORTANT: Perform filter sync BEFORE drilldown
      // This ensures the filter state is updated to match the tapped area
      _syncFiltersWithTappedArea(
        tappedPolygon,
      ); //! should also clear the filter if it is country level

      if (tappedPolygon.canDrillDown) {
        logg.i("Drilling down to: ${tappedPolygon.areaName}");
        _performDrillDown(tappedPolygon);
      } else {
        logg.i(
          "Cannot drill down to ${tappedPolygon.areaName} - no detailed data available",
        );
        showCustomSnackBar(
          context: context,
          message: 'No more detailed map available',
          color: Colors.blueGrey.shade600,
        );
      }
    } else {
      logg.i("No polygon found at tapped location");
    }
  }

  /// Sync filter selections with the tapped area using DYNAMIC backend data
  void _syncFiltersWithTappedArea(AreaPolygon tappedPolygon) {
    try {
      // Get the map controller which now contains the sync functionality
      final mapController = ref.read(mapControllerProvider.notifier);

      // Check if filter data is ready
      if (!mapController.isFilterSyncReady) {
        logg.w('🔄 Filter data not ready yet - skipping sync');
        return;
      }

      final String areaId = tappedPolygon.areaId;
      final String areaName = tappedPolygon.areaName;

      logg.i("🎯 DYNAMIC SYNC: Starting for area '$areaName' (ID: '$areaId')");

      if (areaId.isEmpty || areaId == areaName) {
        logg.w("❓ No valid area ID for sync - skipping");
        return;
      }

      // Check if this area ID corresponds to a district
      if (mapController.isDistrictUid(areaId)) {
        logg.d("✅ Found district UID '$areaId' - proceeding with sync");

        // Perform the sync using the map controller's integrated functionality
        mapController.syncFiltersWithDistrict(areaId);
      } else {
        logg.d("ℹ️ Area ID '$areaId' is not a district - no sync needed");
        // This is expected for divisions, upazilas, etc.
      }
    } catch (e) {
      logg.e("❌ Error during dynamic filter sync: $e");
      // Don't show error to user - this is a supplementary feature
    }
  }

  /// Perform drilldown to the selected area
  void _performDrillDown(AreaPolygon tappedPolygon) {
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Clear any existing error state before drilldown
    mapNotifier.clearError();

    // Determine the next level based on current level
    final currentLevel = ref.read(mapControllerProvider).currentLevel;
    final nextLevel = currentLevel.nextLevel;

    if (nextLevel == null) {
      logg.w("Cannot drill down further from ${currentLevel.value}");
      return;
    }

    // Show a subtle loading indicator and perform the drilldown
    showCustomSnackBar(
      context: context,
      message: 'Loading ${tappedPolygon.areaName.excludeParentheses()}...',
      color: Colors.blueGrey.shade600,
      isLoading: true,
    );

    // Perform the drilldown
    mapNotifier.drillDownToArea(
      areaName: tappedPolygon.areaName,
      slug: tappedPolygon.slug!,
      newLevel: nextLevel.value,
      parentSlug: tappedPolygon.parentSlug,
    );
  }

  /// Handle EPI marker tap - navigate to EPI center details screen
  void _onEpiMarkerTap(
    String epiUid,
    // EpiInfo? info,
  ) {
    logUidInfo(
      source: "Map Interaction (EPI Marker Tap)",
      layer: "Map Interaction",
      name: "EPI Center Marker",
      uid: epiUid,
    );
    logg.i("EPI marker tapped: (UID: $epiUid)");

    if (epiUid.isEmpty) {
      logg.w("EPI marker has no UID, cannot navigate to details");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('EPI center details not available'),
          backgroundColor: Colors.orangeAccent.shade200,
        ),
      );
      return;
    }

    // Get current context for navigation
    final currentState = ref.read(mapControllerProvider);
    final filterState = ref.read(filterControllerProvider);

    // Determine if we're in city corporation context
    String? ccUid;
    if (filterState.selectedAreaType == AreaType.cityCorporation) {
      // Extract city corporation UID from current navigation or filter
      ccUid = filterState.selectedCityCorporation;
    }

    // Navigate to EPI center details screen
    logg.i("🚀 Navigating to EPI center details:");
    logg.i("   EPI UID: $epiUid");
    logg.i("   CC UID: $ccUid");
    logg.i("   Current Level: ${currentState.currentLevel}");

    // ✅ Get coverage data and selected vaccine for consistent target calculation
    final summaryState = ref.read(summaryControllerProvider);
    final coverageData = summaryState.coverageData;
    final selectedVaccineUid = filterState.selectedVaccine;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpiCenterDetailsScreen(
          epiUid: epiUid,
          ccUid: ccUid,
          currentLevel: null, // TODO: Review if this level conversion is needed
          coverageData: coverageData, // ✅ Pass coverage data
          selectedVaccineUid: selectedVaccineUid, // ✅ Pass selected vaccine
        ),
      ),
    );
  }

  /// Auto-navigate to EPI center details when subblock filter is applied
  void _navigateToEpiCenterDetailsForSubblock(
    BuildContext context,
    WidgetRef ref,
    String subblockName,
  ) {
    // ✅ Check if we're already on EPI details screen to prevent duplicate navigation
    final currentRoute = ModalRoute.of(context);
    if (currentRoute?.settings.name?.contains('EpiCenterDetails') == true) {
      logg.i("⚠️ Already on EPI center details screen, skipping auto-navigation");
      return;
    }
    
    logg.i("🚀 Auto-navigating to EPI center details for subblock: $subblockName");
    
    final filterState = ref.read(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);
    final summaryState = ref.read(summaryControllerProvider);
    
    // Get subblock UID
    final subblockUid = filterNotifier.getSubblockUid(subblockName);
    
    if (subblockUid == null) {
      logg.w("⚠️ Could not get subblock UID for $subblockName, skipping auto-navigation");
      return;
    }
    
    logg.i("   > Subblock UID: $subblockUid");
    logg.i("   > Coverage data available: ${summaryState.coverageData != null}");
    logg.i("   > Selected vaccine UID: ${filterState.selectedVaccine}");
    
    // Get coverage data and selected vaccine
    final coverageData = summaryState.coverageData;
    final selectedVaccineUid = filterState.selectedVaccine;
    
    // Navigate to EPI center details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpiCenterDetailsScreen(
          epiUid: subblockUid,
          isOrgUidRequest: true,
          coverageData: coverageData,
          selectedVaccineUid: selectedVaccineUid,
        ),
      ),
    );
  }

  /// Handle subblock tap - find EPI center in subblock and navigate to it
  void _handleSubblockTapForEpiNavigation(AreaPolygon subblockPolygon) {
    logg.i("Subblock tapped: ${subblockPolygon.areaName}");

    final mapState = ref.read(mapControllerProvider);
    final epiData = mapState.epiCenterCoordsData;

    if (epiData?.features == null || epiData!.features!.isEmpty) {
      logg.w("No EPI data available for subblock navigation");
      showCustomSnackBar(
        context: context,
        message: 'EPI center data not available',
        color: Colors.orangeAccent.shade200,
      );
      return;
    }

    // Find EPI center within this subblock polygon
    EpiInfo? foundEpiCenter;
    for (final feature in epiData.features!) {
      if (feature.geometry?.type == 'Point' &&
          feature.geometry?.coordinates != null &&
          feature.info?.orgUid != null) {
        final coords = feature.geometry!.coordinates!;
        final lng = (coords[0] as num).toDouble();
        final lat = (coords[1] as num).toDouble();
        final epiPoint = LatLng(lat, lng);

        // Check if this EPI center is inside the subblock polygon
        if (isTappedPointInPolygon(epiPoint, subblockPolygon.polygon.points)) {
          foundEpiCenter = feature.info;
          break;
        }
      }
    }

    if (foundEpiCenter == null || foundEpiCenter.orgUid == null) {
      logg.w(
        "No EPI center found within subblock: ${subblockPolygon.areaName}",
      );
      showCustomSnackBar(
        context: context,
        message: 'No EPI center found in this area',
        color: Colors.orangeAccent.shade200,
      );
      return;
    }

    // Navigate to EPI center details using the same logic as EPI icon tap
    logg.i(
      "Found EPI center in subblock: ${foundEpiCenter.name} (${foundEpiCenter.orgUid})",
    );
    _onEpiMarkerTap(foundEpiCenter.orgUid!);
  }

  /// Handle city corporation ward tap - navigate directly to EPI details using org_uid
  void _handleCityCorporationWardTapForEpiNavigation(AreaPolygon wardPolygon) {
    logg.i("City Corporation Ward tapped: ${wardPolygon.areaName}");

    if (wardPolygon.orgUid == null || wardPolygon.orgUid!.isEmpty) {
      logg.w("No org_uid available for ward: ${wardPolygon.areaName}");
      showCustomSnackBar(
        context: context,
        message: 'Ward data not available',
        color: Colors.orangeAccent.shade200,
      );
      return;
    }

    logg.i(
      "Navigating to EPI details for CC ward: ${wardPolygon.areaName} (org_uid: ${wardPolygon.orgUid})",
    );

    // ✅ Get coverage data and selected vaccine for consistent target calculation
    final summaryState = ref.read(summaryControllerProvider);
    final filterState = ref.read(filterControllerProvider);
    final coverageData = summaryState.coverageData;
    final selectedVaccineUid = filterState.selectedVaccine;

    // Navigate to EPI center details screen using org_uid
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpiCenterDetailsScreen(
          epiUid: wardPolygon.orgUid!,
          ccUid: null, // Not needed for direct org_uid calls
          currentLevel:
              GeographicLevel.zone.index, // Ward within city corporation
          isOrgUidRequest: true, // Flag to use org_uid-based API call
          coverageData: coverageData, // ✅ Pass coverage data
          selectedVaccineUid: selectedVaccineUid, // ✅ Pass selected vaccine
        ),
      ),
    );
  }

  /// Go back one level in navigation
  void _goBack() {
    final currentState = ref.read(mapControllerProvider);
    final mapNotifier = ref.read(mapControllerProvider.notifier);

    // Clear any existing error state before going back
    mapNotifier.clearError();

    // If going back to country level, also reset map zoom
    if (currentState.navigationStack.length == 1) {
      // This will be the last level, so next will be country
      Future.delayed(const Duration(milliseconds: 100), () {
        logg.i("Resetting zoom to country view after going back");
        mapController.moveAndRotate(LatLng(23.6850, 90.3563), _initialZoom, 0);
      });
    }

    mapNotifier.goBack();
  }

  @override
  void dispose() {
    _autoZoomTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

    // Parse polygons when we have both GeoJSON and coverage data - MOVE BEFORE LISTENER
    List<AreaPolygon> areaPolygons = [];
    if (mapState.areaCoordsGeoJsonData != null &&
        mapState.coverageData != null) {
      try {
        areaPolygons = parseGeoJsonToPolygons(
          mapState.areaCoordsGeoJsonData!,
          mapState.coverageData!,
          filterState.selectedVaccine,
          mapState.currentLevel.value,
        );
        // logg.i("Successfully parsed ${areaPolygons.length} polygons");

        // Clear any existing errors when data is successfully loaded and parsed
        if (mapState.error != null && !mapState.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(mapControllerProvider.notifier).clearError();
          });
        }
      } catch (e) {
        logg.e("Error parsing polygons: $e");
        areaPolygons = [];
      }
    }

    // Listen for state changes to trigger auto-zoom after drilldown
    ref.listen<dynamic>(mapControllerProvider, (previous, current) {
      // Hide any loading snackbars when state changes
      if (previous?.isLoading == true && current.isLoading == false) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Check if we just finished loading after a drilldown or filter application
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          (current.currentLevel !=
                  GeographicLevel.district || // All non-district levels
              (current.currentLevel ==
                      GeographicLevel
                          .district && //? may cause issue, needs testing
                  current.navigationStack.isNotEmpty) || // District from filter
              current.currentLevel ==
                  GeographicLevel.division || // Division from filter
              filterState.selectedAreaType ==
                  AreaType.cityCorporation) && // City corporation from filter
          current.areaCoordsGeoJsonData != null &&
          current.coverageData != null) {
        // Throttle auto-zoom to prevent rapid calls and freezing
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 800) {
          logg.i("Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer to prevent overlapping operations
        _autoZoomTimer?.cancel();

        // Schedule auto-zoom after tiles load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            if (mounted) {
              // Parse fresh polygons for auto-zoom
              final filterState = ref.read(filterControllerProvider);
              final freshPolygons = parseGeoJsonToPolygons(
                current.areaCoordsGeoJsonData!,
                current.coverageData!,
                filterState.selectedVaccine,
                current.currentLevel.value,
              );

              if (freshPolygons.isNotEmpty) {
                // logg.i(
                //   "Auto-zooming to ${freshPolygons.length} polygons at level: ${current.currentLevel}",
                // );
                _autoZoomToPolygons(
                  freshPolygons,
                ); //? what if we try with old polygons e.g. areaPolygons?
              } else {
                // logg.w("No polygons available for auto-zoom");
              }
            } else {
              // logg.w("Skipping auto-zoom - widget unmounted");
            }
          } catch (e) {
            // logg.w("Auto-zoom failed: $e");
          }
        });
      }
    });

    // this reloads coverage data when year changes
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      // 🛡️ COMPREHENSIVE EPI CONTEXT CHECK - Skip ALL map operations when in EPI context
      if (current.isEpiDetailsContext) {
        logg.i("🚫 Map: Ignoring filter changes - in EPI context");
        logg.i(
          "   Context details: isEpiDetailsContext=${current.isEpiDetailsContext}",
        );
        return; // Skip all map reload operations when in EPI context
      }

      // ✅ Normal map operations (only when NOT in EPI context)
      if (previous != null && (previous.selectedYear != current.selectedYear)) {
        logg.i(
          "Map: Year changed from ${previous.selectedYear} to ${current.selectedYear}",
        );

        // Refresh coverage data for the new year
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref
                .read(mapControllerProvider.notifier)
                .refreshCoverageForYearChange();
          }
        });
      }

      // Only trigger map loading when filters are actually applied (filter button pressed)
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        // 🛡️ DOUBLE-CHECK: Additional safety check for EPI context
        // (Belt and suspenders approach - should already be caught above)
        if (current.isEpiDetailsContext) {
          logg.w(
            "🚨 Map: EPI context detected in filter application - this should have been caught earlier!",
          );
          logg.w("   Skipping map reload as safety measure");
          return;
        }

        logg.i("✅ Map: Filter applied - triggering map data load");

        // Check if only vaccine changed (no geographic filter changes)
        // ✅ FIX: Include hierarchical filters (upazila, union, ward, subblock) in change detection
        final bool onlyVaccineChanged =
            previous.selectedAreaType == current.selectedAreaType &&
            previous.selectedDivision == current.selectedDivision &&
            previous.selectedDistrict == current.selectedDistrict &&
            previous.selectedCityCorporation ==
                current.selectedCityCorporation &&
            previous.selectedUpazila == current.selectedUpazila &&
            previous.selectedUnion == current.selectedUnion &&
            previous.selectedWard == current.selectedWard &&
            previous.selectedSubblock == current.selectedSubblock &&
            previous.selectedZone == current.selectedZone &&
            previous.selectedYear == current.selectedYear &&
            previous.selectedVaccine != current.selectedVaccine;

        if (onlyVaccineChanged) {
          logg.i(
            "Only vaccine changed from ${previous.selectedVaccine} to ${current.selectedVaccine} - no loading needed, map will auto-update",
          );
          // DO NOT call any map controller methods for vaccine-only changes
          // The map will automatically re-render with the new vaccine selection
          // because the widget build method uses filterState.selectedVaccine
          return; // Early return to avoid any loading operations
        }

        final bool divisionFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDivision != 'All' &&
            current.selectedDistrict == null &&
            current.selectedUpazila == null;

        // ✅ FIX: Log warnings when union/ward is selected but parent levels are missing
        if (current.selectedUnion != null &&
            (current.selectedDistrict == null || current.selectedUpazila == null)) {
          logg.w(
            "⚠️ Union filter selected but parent levels missing: "
            "district=${current.selectedDistrict}, upazila=${current.selectedUpazila}",
          );
        }
        if (current.selectedWard != null &&
            (current.selectedDistrict == null ||
                current.selectedUpazila == null ||
                current.selectedUnion == null)) {
          logg.w(
            "⚠️ Ward filter selected but parent levels missing: "
            "district=${current.selectedDistrict}, upazila=${current.selectedUpazila}, union=${current.selectedUnion}",
          );
        }

        // Detect deepest hierarchical selection for District area type
        // ✅ FIX: Validate parent levels are set for subblock filter
        final bool subblockFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedWard != null &&
            current.selectedSubblock != null &&
            current.selectedSubblock != 'All';
        // ✅ FIX: Validate parent levels are set for ward filter
        final bool wardFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedWard != null &&
            current.selectedWard != 'All' &&
            (current.selectedSubblock == null || current.selectedSubblock == 'All');
        // ✅ FIX: Validate parent levels are set for union filter
        final bool unionFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedUnion != 'All' &&
            (current.selectedWard == null || current.selectedWard == 'All');
        final bool upazilaFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedUpazila != null &&
            current.selectedUpazila != 'All' &&
            (current.selectedUnion == null || current.selectedUnion == 'All');
        final bool districtFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedDistrict != 'All' &&
            (current.selectedUpazila == null || current.selectedUpazila == 'All');

        final bool zoneFilterApplied =
            current.selectedAreaType == AreaType.cityCorporation &&
            current.selectedCityCorporation != null &&
            current.selectedZone != null &&
            current.selectedZone != 'All';
        final bool cityCorporationFilterApplied =
            current.selectedAreaType == AreaType.cityCorporation &&
            current.selectedCityCorporation != null &&
            (current.selectedZone == null || current.selectedZone == 'All');
        final bool allCityCorporationsView =
            current.selectedAreaType == AreaType.cityCorporation &&
            current.selectedCityCorporation == null;
        // ✅ FIX: Check that all hierarchical selections are cleared for country reset
        final bool shouldResetToCountry =
            current.selectedAreaType == AreaType.district &&
            current.selectedDivision == 'All' &&
            current.selectedDistrict == null &&
            current.selectedUpazila == null &&
            current.selectedUnion == null &&
            current.selectedWard == null &&
            current.selectedSubblock == null;

        // Load data based on deepest selection (hierarchical priority)
        // ✅ FIX: Check from deepest to shallowest (subblock -> ward -> union -> upazila -> district)
        // This ensures when all filters are applied at once, the deepest level is selected
        logg.i(
          '🔍 Filter Detection: '
          'subblock=$subblockFilterApplied (${current.selectedSubblock}), '
          'ward=$wardFilterApplied (${current.selectedWard}), '
          'union=$unionFilterApplied (${current.selectedUnion}), '
          'upazila=$upazilaFilterApplied (${current.selectedUpazila}), '
          'district=$districtFilterApplied (${current.selectedDistrict})',
        );
        if (subblockFilterApplied) {
          logg.i("Subblock filter applied: ${current.selectedSubblock}");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              // ✅ FIX: Wait for subblocks to be loaded before calling loadSubblockData
              // This prevents race condition where loadSubblockData is called before
              // subblocks list is populated in filter controller
              final subblockName = current.selectedSubblock!;
              
              // Check if subblocks are already loaded
              var currentFilterState = ref.read(filterControllerProvider);
              
              // ✅ FIX: First ensure wards are loaded (subblocks depend on wards)
              if (currentFilterState.wards.isEmpty) {
                logg.i("Wards not loaded yet, loading them first before subblocks...");
                
                // Proactively load wards if union is selected
                final selectedUnion = currentFilterState.selectedUnion;
                if (selectedUnion != null && selectedUnion != 'All') {
                  final filterNotifier = ref.read(filterControllerProvider.notifier);
                  
                  // Wait for unions to load if needed
                  if (currentFilterState.unions.isEmpty) {
                    logg.i("Unions not loaded yet, loading them first...");
                    final selectedUpazila = currentFilterState.selectedUpazila;
                    if (selectedUpazila != null && selectedUpazila != 'All') {
                      final upazilaUid = filterNotifier.getUpazilaUid(selectedUpazila);
                      if (upazilaUid != null) {
                        await filterNotifier.loadUnionsByUpazila(upazilaUid);
                        currentFilterState = ref.read(filterControllerProvider);
                      }
                    }
                    
                    // Wait for unions to load
                    int unionRetries = 0;
                    while (unionRetries < 30 && mounted && currentFilterState.unions.isEmpty) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      currentFilterState = ref.read(filterControllerProvider);
                      unionRetries++;
                    }
                  }
                  
                  // Now load wards
                  final unionUid = filterNotifier.getUnionUid(selectedUnion);
                  if (unionUid != null) {
                    logg.i("Loading wards for union: $selectedUnion (UID: $unionUid)");
                    await filterNotifier.loadWardsByUnion(unionUid);
                    currentFilterState = ref.read(filterControllerProvider);
                  }
                }
                
                // Wait for wards to load (max 5 seconds)
                int wardRetries = 0;
                const maxWardRetries = 50;
                
                while (wardRetries < maxWardRetries && mounted && currentFilterState.wards.isEmpty) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  currentFilterState = ref.read(filterControllerProvider);
                  if (currentFilterState.wards.isNotEmpty) {
                    logg.i("Wards loaded (${currentFilterState.wards.length} items), proceeding with subblock loading");
                    break;
                  }
                  wardRetries++;
                }
                
                if (currentFilterState.wards.isEmpty) {
                  logg.e(
                    "Cannot load subblock data: Wards list is still empty after waiting. "
                    "Union: ${currentFilterState.selectedUnion}, "
                    "Available unions: ${currentFilterState.unions.map((u) => u.name).toList()}",
                  );
                  return; // Don't proceed if wards aren't loaded
                }
              }
              
              // Now that wards are loaded, load subblocks
              if (currentFilterState.subblocks.isEmpty) {
                logg.i("Subblocks not loaded yet, attempting to load them...");
                
                // Proactively load subblocks if ward is selected
                if (currentFilterState.selectedWard != null && 
                    currentFilterState.selectedWard != 'All') {
                  final wardName = currentFilterState.selectedWard!;
                  final filterNotifier = ref.read(filterControllerProvider.notifier);
                  final wardUid = filterNotifier.getWardUid(wardName);
                  
                  if (wardUid != null) {
                    // Load subblocks directly using the public method
                    logg.i("Triggering subblock load for ward: $wardName (UID: $wardUid)");
                    await filterNotifier.loadSubblocksByWard(wardUid);
                    // Refresh filter state after loading
                    currentFilterState = ref.read(filterControllerProvider);
                  } else {
                    logg.w(
                      "Could not get ward UID for $wardName to load subblocks. "
                      "Available wards: ${currentFilterState.wards.map((w) => w.name).toList()}",
                    );
                  }
                }
                
                // Wait for subblocks to load (max 5 seconds)
                int retries = 0;
                const maxRetries = 50;
                
                while (retries < maxRetries && mounted) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  currentFilterState = ref.read(filterControllerProvider);
                  if (currentFilterState.subblocks.isNotEmpty) {
                    logg.i("Subblocks loaded (${currentFilterState.subblocks.length} items), proceeding with loadSubblockData");
                    break;
                  }
                  retries++;
                }
                
                if (currentFilterState.subblocks.isEmpty) {
                  logg.e(
                    "Cannot load subblock data: Subblocks list is still empty after all retries. "
                    "Subblock: $subblockName, Ward: ${currentFilterState.selectedWard}, "
                    "Available wards: ${currentFilterState.wards.map((w) => w.name).toList()}",
                  );
                  return; // Don't proceed if subblocks aren't loaded
                }
              }
              
              // Check if subblock exists with fuzzy matching (handles name variations)
              final subblockExists = currentFilterState.subblocks.any(
                (subblock) {
                  final normalizedSubblockName = subblock.name?.trim() ?? '';
                  final normalizedSearchName = subblockName.trim();
                  // Exact match
                  if (normalizedSubblockName == normalizedSearchName) return true;
                  // Case-insensitive match
                  if (normalizedSubblockName.toLowerCase() == normalizedSearchName.toLowerCase()) return true;
                  // Partial match (for names with "(Part ...)" suffix)
                  final subblockBaseName = normalizedSubblockName.split(' (')[0].trim();
                  final searchBaseName = normalizedSearchName.split(' (')[0].trim();
                  if (subblockBaseName.toLowerCase() == searchBaseName.toLowerCase()) return true;
                  return false;
                },
              );
              
              if (!subblockExists && currentFilterState.subblocks.isNotEmpty) {
                logg.w(
                  "⚠️ Subblock '$subblockName' not found in subblocks list. "
                  "Available subblocks: ${currentFilterState.subblocks.map((s) => s.name).toList()}. "
                  "Attempting to load anyway (getSubblockUid will handle fuzzy matching).",
                );
              } else if (subblockExists) {
                logg.i(
                  "✅ Subblock '$subblockName' found in subblocks list (${currentFilterState.subblocks.length} total subblocks), proceeding with loadSubblockData",
                );
              }
              
              // Try to load - getSubblockUid will handle fuzzy matching
              await ref
                  .read(mapControllerProvider.notifier)
                  .loadSubblockData(subblockName: subblockName);
              
              // ✅ FIX: Auto-navigate to EPI center details when subblock filter is applied
              // Wait a bit for map state to update, then check if data loaded successfully
              await Future.delayed(const Duration(milliseconds: 500));
              
              if (mounted) {
                // Check if data loaded successfully (no error, not loading)
                final mapState = ref.read(mapControllerProvider);
                if (!mapState.isLoading && mapState.error == null) {
                  logg.i("✅ Subblock data loaded successfully, auto-navigating to EPI center details");
                  _navigateToEpiCenterDetailsForSubblock(
                    context,
                    ref,
                    subblockName,
                  );
                } else {
                  logg.w(
                    "⚠️ Skipping auto-navigation - map state: isLoading=${mapState.isLoading}, error=${mapState.error}",
                  );
                }
              }
            }
          });
        } else if (wardFilterApplied) {
          logg.i("Ward filter applied: ${current.selectedWard}");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              // ✅ FIX: Wait for wards to be loaded before calling loadWardData
              // This prevents race condition where loadWardData is called before
              // wards list is populated in filter controller
              final wardName = current.selectedWard!;
              
              // Check if wards are already loaded
              var currentFilterState = ref.read(filterControllerProvider);
              if (currentFilterState.wards.isEmpty) {
                logg.i("Wards not loaded yet, attempting to load them...");
                
                // ✅ FIX: Proactively load wards if they're empty
                // This happens when ward filter is applied but wards weren't loaded yet
                final selectedUnion = currentFilterState.selectedUnion;
                if (selectedUnion != null && selectedUnion != 'All') {
                  final filterNotifier = ref.read(filterControllerProvider.notifier);
                  
                  // ✅ FIX: Wait for unions to be loaded before getting union UID
                  if (currentFilterState.unions.isEmpty) {
                    logg.i("Unions not loaded yet, attempting to load them...");
                    
                    // Try to load unions if upazila is selected
                    final selectedUpazila = currentFilterState.selectedUpazila;
                    if (selectedUpazila != null && selectedUpazila != 'All') {
                      final upazilaUid = filterNotifier.getUpazilaUid(selectedUpazila);
                      if (upazilaUid != null) {
                        logg.i("Loading unions for upazila: $selectedUpazila (UID: $upazilaUid)");
                        await filterNotifier.loadUnionsByUpazila(upazilaUid);
                        // Refresh state after loading
                        currentFilterState = ref.read(filterControllerProvider);
                      } else {
                        logg.w("Could not get upazila UID for $selectedUpazila to load unions");
                      }
                    }
                    
                    // Wait for unions to load (max 3 seconds, check every 100ms)
                    int unionRetries = 0;
                    const maxUnionRetries = 30; // 30 * 100ms = 3 seconds
                    
                    while (unionRetries < maxUnionRetries && mounted && currentFilterState.unions.isEmpty) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      currentFilterState = ref.read(filterControllerProvider);
                      
                      if (currentFilterState.unions.isNotEmpty) {
                        logg.i("Unions loaded (${currentFilterState.unions.length} items), proceeding with ward loading");
                        break;
                      }
                      
                      unionRetries++;
                    }
                    
                    if (currentFilterState.unions.isEmpty) {
                      logg.w("Unions still not loaded after waiting, attempting to load wards anyway");
                    }
                  }
                  
                  // Now try to get union UID
                  final unionUid = filterNotifier.getUnionUid(selectedUnion);
                  if (unionUid != null) {
                    logg.i("Loading wards for union: $selectedUnion (UID: $unionUid)");
                    await filterNotifier.loadWardsByUnion(unionUid);
                    // Refresh state after loading
                    currentFilterState = ref.read(filterControllerProvider);
                  } else {
                    logg.w(
                      "Could not get union UID for $selectedUnion to load wards. "
                      "Available unions: ${currentFilterState.unions.map((u) => u.name).toList()}",
                    );
                  }
                }
                
                // Wait for wards to load (max 5 seconds, check every 100ms)
                int retries = 0;
                const maxRetries = 50; // 50 * 100ms = 5 seconds (increased timeout)
                
                while (retries < maxRetries && mounted && currentFilterState.wards.isEmpty) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  currentFilterState = ref.read(filterControllerProvider);
                  
                  if (currentFilterState.wards.isNotEmpty) {
                    logg.i("Wards loaded (${currentFilterState.wards.length} items), proceeding with loadWardData");
                    break;
                  }
                  
                  retries++;
                  
                  // Log progress every second
                  if (retries % 10 == 0) {
                    logg.i("Still waiting for wards to load... (${retries * 100}ms elapsed, union: $selectedUnion)");
                  }
                }
                
                if (currentFilterState.wards.isEmpty) {
                  logg.e(
                    "Wards still not loaded after waiting ${retries * 100}ms. "
                    "Union: $selectedUnion, Available unions: ${currentFilterState.unions.map((u) => u.name).toList()}",
                  );
                  
                  // Try one more time to load wards if union UID is available
                  if (selectedUnion != null && selectedUnion != 'All' && mounted) {
                    final filterNotifier = ref.read(filterControllerProvider.notifier);
                    final unionUid = filterNotifier.getUnionUid(selectedUnion);
                    if (unionUid != null) {
                      logg.i("Retrying ward loading with union UID: $unionUid");
                      await filterNotifier.loadWardsByUnion(unionUid);
                      currentFilterState = ref.read(filterControllerProvider);
                      
                      // Wait a bit more after retry
                      if (currentFilterState.wards.isEmpty) {
                        await Future.delayed(const Duration(milliseconds: 500));
                        currentFilterState = ref.read(filterControllerProvider);
                      }
                    } else {
                      logg.w("Could not get union UID for retry: $selectedUnion");
                    }
                  }
                }
              } else {
                logg.i("Wards already loaded (${currentFilterState.wards.length} items), proceeding immediately");
              }
              
              // ✅ FIX: Only try to load ward data if wards are loaded
              if (mounted) {
                // Final check - refresh state one more time
                currentFilterState = ref.read(filterControllerProvider);
                
                if (currentFilterState.wards.isEmpty) {
                  logg.e(
                    "Cannot load ward data: Wards list is still empty after all retries. "
                    "Ward: $wardName, Union: ${currentFilterState.selectedUnion}, "
                    "Available unions: ${currentFilterState.unions.map((u) => u.name).toList()}",
                  );
                  return; // Don't proceed if wards aren't loaded
                }
                
                // Check if ward exists with fuzzy matching (handles name variations)
                final wardExists = currentFilterState.wards.any(
                  (ward) {
                    final normalizedWardName = ward.name?.trim() ?? '';
                    final normalizedSearchName = wardName.trim();
                    // Exact match
                    if (normalizedWardName == normalizedSearchName) return true;
                    // Case-insensitive match
                    if (normalizedWardName.toLowerCase() == normalizedSearchName.toLowerCase()) return true;
                    // Partial match (for names with "(Part ...)" suffix)
                    final wardBaseName = normalizedWardName.split(' (')[0].trim();
                    final searchBaseName = normalizedSearchName.split(' (')[0].trim();
                    if (wardBaseName.toLowerCase() == searchBaseName.toLowerCase()) return true;
                    return false;
                  },
                );
                
                if (!wardExists && currentFilterState.wards.isNotEmpty) {
                  logg.w(
                    "⚠️ Ward '$wardName' not found in wards list. "
                    "Available wards: ${currentFilterState.wards.map((w) => w.name).toList()}. "
                    "Attempting to load anyway (getWardUid will handle fuzzy matching).",
                  );
                } else if (wardExists) {
                  logg.i(
                    "✅ Ward '$wardName' found in wards list (${currentFilterState.wards.length} total wards), proceeding with loadWardData",
                  );
                }
                
                // Try to load - getWardUid will handle fuzzy matching
                ref
                    .read(mapControllerProvider.notifier)
                    .loadWardData(wardName: wardName);
              }
            }
          });
        } else if (unionFilterApplied) {
          logg.i("Union filter applied: ${current.selectedUnion}");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              // ✅ FIX: Wait for unions to be loaded before calling loadUnionData
              // This prevents race condition where loadUnionData is called before
              // unions list is populated in filter controller
              final unionName = current.selectedUnion!;
              
              // Check if unions are already loaded
              var currentFilterState = ref.read(filterControllerProvider);
              if (currentFilterState.unions.isEmpty) {
                logg.i("Unions not loaded yet, attempting to load them...");
                
                // ✅ FIX: Proactively load unions if they're empty
                // This happens when union filter is applied but unions weren't loaded yet
                final selectedUpazila = currentFilterState.selectedUpazila;
                if (selectedUpazila != null && selectedUpazila != 'All') {
                  final filterNotifier = ref.read(filterControllerProvider.notifier);
                  
                  // ✅ FIX: Wait for upazilas to be loaded before getting upazila UID
                  if (currentFilterState.upazilas.isEmpty) {
                    logg.i("Upazilas not loaded yet, waiting for them to load...");
                    
                    // Wait for upazilas to load (max 3 seconds, check every 100ms)
                    int upazilaRetries = 0;
                    const maxUpazilaRetries = 30; // 30 * 100ms = 3 seconds
                    
                    while (upazilaRetries < maxUpazilaRetries && mounted && currentFilterState.upazilas.isEmpty) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      currentFilterState = ref.read(filterControllerProvider);
                      
                      if (currentFilterState.upazilas.isNotEmpty) {
                        logg.i("Upazilas loaded (${currentFilterState.upazilas.length} items), proceeding with union loading");
                        break;
                      }
                      
                      upazilaRetries++;
                    }
                    
                    if (currentFilterState.upazilas.isEmpty) {
                      logg.w("Upazilas still not loaded after waiting, attempting to load unions anyway");
                    }
                  }
                  
                  // Now try to get upazila UID
                  final upazilaUid = filterNotifier.getUpazilaUid(selectedUpazila);
                  if (upazilaUid != null) {
                    logg.i("Loading unions for upazila: $selectedUpazila (UID: $upazilaUid)");
                    await filterNotifier.loadUnionsByUpazila(upazilaUid);
                    // Refresh state after loading
                    currentFilterState = ref.read(filterControllerProvider);
                  } else {
                    logg.w(
                      "Could not get upazila UID for $selectedUpazila to load unions. "
                      "Available upazilas: ${currentFilterState.upazilas.map((u) => u.name).toList()}",
                    );
                  }
                }
                
                // Wait for unions to load (max 3 seconds, check every 100ms)
                int retries = 0;
                const maxRetries = 30; // 30 * 100ms = 3 seconds
                
                while (retries < maxRetries && mounted && currentFilterState.unions.isEmpty) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  currentFilterState = ref.read(filterControllerProvider);
                  
                  if (currentFilterState.unions.isNotEmpty) {
                    logg.i("Unions loaded (${currentFilterState.unions.length} items), proceeding with loadUnionData");
                    break;
                  }
                  
                  retries++;
                }
                
                if (currentFilterState.unions.isEmpty) {
                  logg.w("Unions still not loaded after waiting, attempting to load anyway");
                }
              } else {
                logg.i("Unions already loaded (${currentFilterState.unions.length} items), proceeding immediately");
              }
              
              // ✅ FIX: Try to load union data even if exact match fails (getUnionUid handles fuzzy matching)
              if (mounted) {
                // Check if union exists with fuzzy matching (handles name variations)
                final unionExists = currentFilterState.unions.any(
                  (union) {
                    final normalizedUnionName = union.name?.trim() ?? '';
                    final normalizedSearchName = unionName.trim();
                    // Exact match
                    if (normalizedUnionName == normalizedSearchName) return true;
                    // Case-insensitive match
                    if (normalizedUnionName.toLowerCase() == normalizedSearchName.toLowerCase()) return true;
                    // Partial match (for names with "(Part ...)" suffix)
                    final unionBaseName = normalizedUnionName.split(' (')[0].trim();
                    final searchBaseName = normalizedSearchName.split(' (')[0].trim();
                    if (unionBaseName.toLowerCase() == searchBaseName.toLowerCase()) return true;
                    return false;
                  },
                );
                
                if (!unionExists && currentFilterState.unions.isNotEmpty) {
                  logg.w(
                    "⚠️ Union '$unionName' not found in unions list. "
                    "Available unions: ${currentFilterState.unions.map((u) => u.name).toList()}. "
                    "Attempting to load anyway (getUnionUid will handle fuzzy matching).",
                  );
                } else if (!unionExists) {
                  logg.w(
                    "⚠️ Union '$unionName' not found - unions list is empty. "
                    "Attempting to load anyway.",
                  );
                } else {
                  logg.i(
                    "✅ Union '$unionName' found in unions list, proceeding with loadUnionData",
                  );
                }
                
                // Always try to load - getUnionUid will handle fuzzy matching
                ref
                    .read(mapControllerProvider.notifier)
                    .loadUnionData(unionName: unionName);
              }
            }
          });
        } else if (upazilaFilterApplied) {
          logg.i("Upazila filter applied: ${current.selectedUpazila}");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              // ✅ FIX: Wait for upazilas to be loaded before calling loadUpazilaData
              // This prevents race condition where loadUpazilaData is called before
              // upazilas list is populated in filter controller
              final upazilaName = current.selectedUpazila!;
              
              // Check if upazilas are already loaded
              var currentFilterState = ref.read(filterControllerProvider);
              if (currentFilterState.upazilas.isEmpty) {
                logg.i("Upazilas not loaded yet, waiting for them to load...");
                
                // Wait for upazilas to load (max 3 seconds, check every 100ms)
                int retries = 0;
                const maxRetries = 30; // 30 * 100ms = 3 seconds
                
                while (retries < maxRetries && mounted) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  currentFilterState = ref.read(filterControllerProvider);
                  
                  if (currentFilterState.upazilas.isNotEmpty) {
                    logg.i("Upazilas loaded (${currentFilterState.upazilas.length} items), proceeding with loadUpazilaData");
                    break;
                  }
                  
                  retries++;
                }
                
                if (currentFilterState.upazilas.isEmpty) {
                  logg.w("Upazilas still not loaded after waiting, attempting to load anyway");
                }
              } else {
                logg.i("Upazilas already loaded (${currentFilterState.upazilas.length} items), proceeding immediately");
              }
              
              // Now call loadUpazilaData with the upazila name
              if (mounted) {
                ref
                    .read(mapControllerProvider.notifier)
                    .loadUpazilaData(upazilaName: upazilaName);
              }
            }
          });
        } else if (districtFilterApplied) {
          logg.i("District filter applied: ${current.selectedDistrict}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadDistrictData(districtName: current.selectedDistrict!);
            }
          });
        } else if (divisionFilterApplied) {
          logg.i("Division filter applied: ${current.selectedDivision}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadDivisionData(divisionName: current.selectedDivision);
            }
          });
        } else if (zoneFilterApplied) {
          logg.i("Zone filter applied: ${current.selectedZone} in ${current.selectedCityCorporation}");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted) {
              final currentFilterState = ref.read(filterControllerProvider);
              
              // ✅ Proactively load zones if not loaded
              if (currentFilterState.zones.isEmpty) {
                logg.i("Zones not loaded, loading zones for CC: ${current.selectedCityCorporation}");
                final ccUid = ref.read(filterControllerProvider.notifier).getCityCorporationUid(
                  current.selectedCityCorporation!,
                );
                if (ccUid != null) {
                  await ref.read(filterControllerProvider.notifier).loadZonesByCityCorporation(ccUid);
                }
              }
              
              // Wait for zones to load (with retry)
              int retries = 0;
              while (retries < 30 && mounted) {
                final checkState = ref.read(filterControllerProvider);
                if (checkState.zones.isNotEmpty) {
                  break;
                }
                await Future.delayed(const Duration(milliseconds: 100));
                retries++;
              }
              
              final finalState = ref.read(filterControllerProvider);
              if (finalState.zones.isEmpty) {
                logg.w("Zones not loaded after waiting ${retries * 100}ms");
                return;
              }
              
              // Verify zone exists in the list
              final zoneName = current.selectedZone!;
              final zoneExists = finalState.zones.any(
                (zone) => zone.name?.trim() == zoneName.trim() ||
                    zone.name?.trim().toLowerCase() == zoneName.trim().toLowerCase(),
              );
              
              if (!zoneExists) {
                logg.w(
                  "Zone '$zoneName' not found in zones list (${finalState.zones.length} total zones). "
                  "Available zones: ${finalState.zones.map((z) => z.name).toList()}",
                );
                return;
              }
              
              logg.i(
                "✅ Zone '$zoneName' found in zones list (${finalState.zones.length} total zones), proceeding with loadZoneData",
              );
              
              if (mounted) {
                ref
                    .read(mapControllerProvider.notifier)
                    .loadZoneData(zoneName: zoneName);
              }
            }
          });
        } else if (cityCorporationFilterApplied) {
          logg.i(
            "City corporation filter applied: ${current.selectedCityCorporation}",
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadCityCorporationData(
                    cityCorporationName: current.selectedCityCorporation!,
                  );
            }
          });
        } else if (allCityCorporationsView) {
          logg.i("All City Corporations view requested");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(mapControllerProvider.notifier)
                  .loadAllCityCorporationsData();
            }
          });
        } else if (shouldResetToCountry) {
          logg.i("Resetting to country level view");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(mapControllerProvider.notifier).resetToCountryLevel();
            }
          });
        }
      }
    });

    return Scaffold(
      body: Column(
        children: [
          if (!mapState.isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HeaderTitleIconFilterWidget(),
            ),
          10.h,
          // Breadcrumb Navigation
          if (mapState.canGoBack && !mapState.isLoading)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _goBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      'Home > ${mapState.displayPath}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (kDebugMode)
                    Text(
                      'Level: ${mapState.currentLevel.value.toUpperCase()}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  if (mapState.isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CustomLoadingWidget()),
                    ),

                  // Show map when data is loaded successfully (even if polygons are empty)
                  if (!mapState.isLoading &&
                      mapState.areaCoordsGeoJsonData != null &&
                      mapState.coverageData != null)
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(
                          23.6850,
                          90.3563,
                        ), // Center of Bangladesh
                        initialZoom: _initialZoom,
                        minZoom: 3.5,
                        maxZoom: 18.0,
                        onTap: (tapPosition, point) {
                          _onPolygonTap(point, areaPolygons);
                        },
                      ),
                      children: [
                        // Enhanced tile layer with error handling and network resilience
                        MapTileLayer(),
                        // Area polygons
                        PolygonLayer(
                          polygons: areaPolygons
                              .map((areaPolygon) => areaPolygon.polygon)
                              .toList(),
                        ),

                        // EPI markers (vaccination centers) - Show for levels that have EPI data
                        if (mapState.currentLevel.hasEpiData &&
                            mapState.epiCenterCoordsData != null)
                          MarkerLayer(
                            markers: _buildEpiMarkers(
                              mapState.epiCenterCoordsData,
                            ),
                          ),

                        // Area name labels - Use centralized logic from enum
                        if (mapState.currentLevel.shouldShowAreaLabels)
                          MarkerLayer(
                            markers: _buildAreaNameMarkers(areaPolygons),
                          ),
                      ],
                    ),

                  // Show message when data loaded but no polygons found (less intrusive)
                  if (!mapState.isLoading &&
                      mapState.areaCoordsGeoJsonData != null &&
                      mapState.coverageData != null &&
                      areaPolygons.isEmpty)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 24,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'No map data available for this area',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Show message when app is starting and no data yet (initial state)
                  if (!mapState.isLoading &&
                      mapState.areaCoordsGeoJsonData == null &&
                      mapState.coverageData == null)
                    Positioned(
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Initializing map data...',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Reset geographic filters before retrying initial data load
                                  ref
                                      .read(filterControllerProvider.notifier)
                                      .resetGeographicFiltersToCountryView();
                                  ref
                                      .read(mapControllerProvider.notifier)
                                      .loadInitialData(forceRefresh: true);
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // // Reset Button
                  if (!mapState.isLoading) ...[
                    Positioned(
                      top: 5,
                      left: 5,
                      child: FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                        onPressed: () => _resetToCountryView(
                          currentLevel: mapState.currentLevel,
                        ),
                        child: const Icon(Icons.home, color: Colors.grey),
                      ),
                    ),

                    // Static 4-direction indicator (N, E, S, W)
                    if (mapState.areaCoordsGeoJsonData != null &&
                        mapState.coverageData != null)
                      StaticCompassDirectionIndicatorWidget(),

                    // Compass Icon button which centers current level polygon map
                    if (mapState.currentLevel != GeographicLevel.country)
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          onPressed: () {
                            _centerViewForCurrentLevelPolygonMap(
                              currentLevel: mapState.currentLevel,
                            );
                            logg.d(
                              'Centered view to ${mapState.currentLevel} level',
                            );
                          },
                          child: const Icon(
                            Icons.center_focus_strong,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],

                  // inside your build
                  if (!mapState.isLoading &&
                      mapState.areaCoordsGeoJsonData != null &&
                      mapState.coverageData != null)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: MapCoverageVisualizerCardWidget(
                        currentLevel: mapState.currentLevel,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build markers for area names (only for drilled-down areas)
  List<Marker> _buildAreaNameMarkers(List<AreaPolygon> areaPolygons) {
    // Filter out "Part X" polygons to avoid duplicate labels
    final mainAreaPolygons = areaPolygons
        .where(
          (polygon) =>
              !polygon.areaName.contains('(Part ') ||
              polygon.areaName.endsWith('(Part 1)'),
        )
        .toList();

    // With comprehensive polygon rendering, we might have many more polygons now
    if (mainAreaPolygons.length > 150) {
      // logg.w(
      //   "Too many areas (${mainAreaPolygons.length}) for name markers, skipping labels",
      // );
      return [];
    }

    // logg.i(
    //   "Building ${mainAreaPolygons.length} area name markers from ${areaPolygons.length} total polygons",
    // );

    return mainAreaPolygons.map((areaPolygon) {
      // Calculate centroid of the polygon using centralized function
      LatLng centroid = calculatePolygonCentroid(areaPolygon.polygon.points);

      // Clean up the area name (remove "Part X" suffix for display)
      String displayName = areaPolygon.areaName;
      if (displayName.contains('(Part 1)')) {
        displayName = displayName.replaceFirst(' (Part 1)', '');
      }

      return Marker(
        point: centroid,
        child: FittedBox(
          fit: BoxFit.none,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 1,
            ), // Reduced padding significantly
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(3), // Smaller border radius
              border: Border.all(
                color: Colors.black38,
                width: 0.3,
              ), // Thinner border
            ),
            child: Text(
              displayName,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ), // Smaller font size and lighter weight
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Build EPI markers (vaccination centers) from EPI data
  List<Marker> _buildEpiMarkers(EpiCenterCoordsResponse? epiCenterCoordsData) {
    if (epiCenterCoordsData == null) return [];

    try {
      final features = epiCenterCoordsData.features;

      if (features == null || features.isEmpty) return [];

      // logg.i("Building ${features.length} EPI markers");

      return features
          .map<Marker>((feature) {
            final geometry = feature.geometry;
            final info = feature.info;

            if (geometry?.type == 'Point' && geometry?.coordinates != null) {
              final coords = geometry!.coordinates as List;
              final lng = (coords[0] as num).toDouble();
              final lat = (coords[1] as num).toDouble();
              final centerName = info?.name ?? 'EPI Center';
              final isFixedCenter = info?.isFixedCenter ?? false;

              return Marker(
                point: LatLng(lat, lng),
                width: 19,
                height: 19,
                child: GestureDetector(
                  onTap: () => _onEpiMarkerTap(info?.orgUid ?? ''),
                  child: Tooltip(
                    message: centerName,
                    child: SizedBox(
                      width: 14, // Force container size with SizedBox
                      height: 14, // Force container size with SizedBox
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFixedCenter
                              ? Colors.blueAccent
                              : Colors.deepPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 1,
                              offset: const Offset(0, 0.5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: !isFixedCenter
                              ? FaIcon(
                                  FontAwesomeIcons.syringe,
                                  size: 10,
                                  color: Colors.white,
                                )
                              : Icon(Icons.home, color: Colors.white, size: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            // Return empty marker for invalid geometry
            return Marker(
              point: const LatLng(0, 0),
              child: const SizedBox.shrink(),
            );
          })
          .where(
            (marker) =>
                marker.point.latitude != 0 || marker.point.longitude != 0,
          )
          .toList();
    } catch (e) {
      logg.e("Error parsing EPI data: $e");
      return [];
    }
  }
}
