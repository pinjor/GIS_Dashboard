import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:gis_dashboard/features/map/domain/area_polygon.dart';
import 'package:gis_dashboard/features/map/presentation/widget/map_tile_layer.dart';
import 'package:gis_dashboard/features/map/utils/map_utils.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';
import 'package:gis_dashboard/features/session_plan/domain/session_plan_coords_response.dart';
import 'package:gis_dashboard/features/session_plan/presentation/controllers/session_plan_controller.dart';
import 'package:gis_dashboard/features/session_plan/presentation/widgets/session_plan_filter_dialog.dart';
import 'package:gis_dashboard/features/filter/filter.dart';
import 'package:gis_dashboard/features/map/presentation/controllers/map_controller.dart';
import 'package:gis_dashboard/core/utils/utils.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';

class SessionPlanScreen extends ConsumerStatefulWidget {
  const SessionPlanScreen({super.key});

  @override
  ConsumerState<SessionPlanScreen> createState() => _SessionPlanScreenState();
}

class _SessionPlanScreenState extends ConsumerState<SessionPlanScreen> {
  final MapController _mapController = MapController();
  final double _initialZoom = 6.6;
  Timer? _autoZoomTimer;
  DateTime? _lastAutoZoom;
  List<Marker>? _cachedMarkers; // Cache markers to avoid rebuilding
  SessionPlanCoordsResponse? _cachedMarkerData; // Track which data was used for cache
  bool _isCurrentlyBuildingMarkers = false; // Track if markers are currently being built

  @override
  void initState() {
    super.initState();
    // ✅ OPTIMIZATION: Check if filters are already applied and load accordingly
    Future.delayed(Duration.zero, () {
      final filterState = ref.read(filterControllerProvider);
      
      // Check if any filters are applied (not just default country view)
      final hasFiltersApplied = (filterState.selectedDistrict != null &&
              filterState.selectedDistrict != 'All') ||
          (filterState.selectedCityCorporation != null &&
              filterState.selectedCityCorporation != 'All') ||
          (filterState.selectedUpazila != null &&
              filterState.selectedUpazila != 'All') ||
          (filterState.selectedUnion != null &&
              filterState.selectedUnion != 'All') ||
          (filterState.selectedWard != null &&
              filterState.selectedWard != 'All') ||
          (filterState.selectedSubblock != null &&
              filterState.selectedSubblock != 'All') ||
          (filterState.selectedZone != null &&
              filterState.selectedZone != 'All');
      
      if (hasFiltersApplied) {
        // Filters are already applied - load with current filter state
        logg.i("Session Plan: Filters detected on init - loading with filter state");
        ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
      } else {
        // No filters applied - load country level data
        logg.i("Session Plan: No filters detected on init - loading country level data");
        ref.read(sessionPlanControllerProvider.notifier).loadInitialData();
      }
    });
  }

  @override
  void dispose() {
    _autoZoomTimer?.cancel();
    super.dispose();
  }

  /// Auto-zoom to fit all polygons with padding
  void _autoZoomToPolygons(List<AreaPolygon> areaPolygons) {
    if (areaPolygons.isEmpty) return;

    // Get current map state to determine geographic level
    // This ensures we use the same level that map controller determined
    final mapState = ref.read(mapControllerProvider);
    GeographicLevel currentLevel = mapState.currentLevel;
    
    // If map state doesn't have a valid level, determine from filter state
    if (currentLevel == GeographicLevel.country) {
      final filterState = ref.read(filterControllerProvider);
      
      // Check from deepest to shallowest level (same logic as map controller)
      if (filterState.selectedSubblock != null &&
          filterState.selectedSubblock != 'All') {
        currentLevel = GeographicLevel.subblock;
      } else if (filterState.selectedWard != null &&
          filterState.selectedWard != 'All') {
        currentLevel = GeographicLevel.ward;
      } else if (filterState.selectedUnion != null &&
          filterState.selectedUnion != 'All') {
        currentLevel = GeographicLevel.union;
      } else if (filterState.selectedUpazila != null &&
          filterState.selectedUpazila != 'All') {
        currentLevel = GeographicLevel.upazila;
      } else if (filterState.selectedZone != null &&
          filterState.selectedZone != 'All') {
        currentLevel = GeographicLevel.zone;
      } else if (filterState.selectedCityCorporation != null &&
          filterState.selectedCityCorporation != 'All') {
        currentLevel = GeographicLevel.cityCorporation;
      } else if (filterState.selectedDistrict != null &&
          filterState.selectedDistrict != 'All') {
        currentLevel = GeographicLevel.district;
      }
    }

    logg.i("Session Plan: Auto-zooming to level: ${currentLevel.value}");
    autoZoomToPolygons(areaPolygons, currentLevel, _mapController);
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => const SessionPlanFilterDialog(),
    );
  }

  // void _onBack() {
  //   Navigator.pop(context);
  // }

  Future<void> _launchMapsUrl(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open map.')));
      }
    }
  }

  List<Marker> _buildSessionPlanMarkers(SessionPlanCoordsResponse data) {
    try {
      // ✅ OPTIMIZATION: Use cached markers if data hasn't changed
      if (_cachedMarkers != null && _cachedMarkerData == data && _cachedMarkers!.isNotEmpty) {
        _isCurrentlyBuildingMarkers = false; // Markers already built
        return _cachedMarkers!;
      }
      
      if (data.features == null) {
        _isCurrentlyBuildingMarkers = false;
        return [];
      }
      
      // ✅ FIX: Set building flag and log marker building start
      _isCurrentlyBuildingMarkers = true;
      logg.i("Session Plan: Starting to build markers (${data.features!.length} features)");

      // ✅ FIX: Dynamically adjust marker limit based on total sessions
      // For large datasets, we need to balance between showing all sessions and preventing crashes
      // Strategy: Show more markers if we have fewer total sessions, limit more if we have many
      // ⚠️ CRASH FIX: Reduced limits to prevent device crashes on low-end devices
      final totalSessions = data.sessionCount ?? data.features!.length;
      int maxMarkers;
      
      if (totalSessions <= 3000) {
        // Small dataset: show all markers
        maxMarkers = totalSessions;
      } else if (totalSessions <= 10000) {
        // Medium dataset: show up to 3000 markers (reduced from 5000)
        maxMarkers = 3000;
      } else {
        // Large dataset: show up to 5000 markers (reduced from 10000 to prevent crashes)
        // This prevents crashes on low-end devices while still showing a good sample
        maxMarkers = 5000;
      }
      
      final allFeatures = data.features!;
      final totalFeatures = allFeatures.length;
      
      if (totalFeatures > maxMarkers) {
        logg.w(
          "Session Plan: ⚠️ Large dataset detected ($totalFeatures features, $totalSessions total sessions). "
          "Limiting to $maxMarkers markers to prevent crash.",
        );
      } else {
        logg.i(
          "Session Plan: ✅ Showing $totalFeatures markers out of $totalSessions total sessions.",
        );
      }

      final markers = <Marker>[];
      final featuresToProcess = totalFeatures > maxMarkers 
          ? allFeatures.take(maxMarkers).toList() 
          : allFeatures;

      int skippedInvalid = 0;
      for (final feature in featuresToProcess) {
        try {
          final geometry = feature.geometry;
          final info = feature.info;

            if (geometry?.type == 'Point' && geometry?.coordinates != null) {
              final coords = geometry!.coordinates!;
              if (coords.length >= 2) {
                // ✅ CRASH FIX: Validate coordinates before parsing
                try {
                  final lngValue = coords[0];
                  final latValue = coords[1];
                  
                  final lng = (lngValue as num).toDouble();
                  final lat = (latValue as num).toDouble();
                  
                  // ✅ CRASH FIX: Validate coordinate ranges (Bangladesh bounds)
                  // Bangladesh: ~20.7°N to 26.6°N, ~88.0°E to 92.7°E
                  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                    logg.w("Session Plan: Skipping invalid coordinates: lat=$lat, lng=$lng");
                    skippedInvalid++;
                    continue;
                  }
                  
                  final centerName = info?.name ?? 'Session Plan Center';
                  final isFixedCenter = info?.isFixedCenter ?? false;

                  markers.add(
                    Marker(
                      point: LatLng(lat, lng),
                      width: 19,
                      height: 19,
                      child: GestureDetector(
                        onTap: () => _launchMapsUrl(lat, lng),
                        child: Tooltip(
                          message: centerName,
                          child: SizedBox(
                            width: 14,
                            height: 14,
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
                    ),
                  );
                } catch (e) {
                  // ✅ CRASH FIX: Catch coordinate parsing errors
                  logg.w("Session Plan: Error parsing coordinates: $e");
                  skippedInvalid++;
                  continue;
                }
              } else {
                skippedInvalid++;
              }
            } else {
              skippedInvalid++;
            }
        } catch (e) {
          // ✅ CRASH FIX: Catch individual marker errors to prevent entire function from failing
          logg.w("Session Plan: Error building marker for feature: $e");
          skippedInvalid++;
          continue; // Skip this feature and continue with next
        }
      }
      
      if (skippedInvalid > 0) {
        logg.w("Session Plan: Skipped $skippedInvalid invalid features");
      }
      
      logg.i(
        "Session Plan: Built ${markers.length} markers "
        "(${totalFeatures > maxMarkers ? 'limited from $totalFeatures' : 'all $totalFeatures'} features, "
        "skipped $skippedInvalid invalid)",
      );
      
      // ✅ OPTIMIZATION: Cache markers and data reference
      _cachedMarkers = markers;
      _cachedMarkerData = data;
      _isCurrentlyBuildingMarkers = false; // Markers building complete
      
      logg.i("Session Plan: ✅ Marker building complete - cached ${markers.length} markers");
      
      return markers;
    } catch (e, stackTrace) {
      // ✅ CRASH FIX: Comprehensive error handling to prevent app crash
      logg.e("Session Plan: Critical error building markers: $e");
      logg.e("Session Plan: Stack trace: $stackTrace");
      _isCurrentlyBuildingMarkers = false; // Reset building flag on error
      return []; // Return empty list instead of crashing
    }
  }

  /// Determine current geographic level from filter state
  GeographicLevel _getCurrentGeographicLevel(FilterState filterState) {
    // Check from deepest to shallowest level (same logic as map controller)
    if (filterState.selectedSubblock != null &&
        filterState.selectedSubblock != 'All') {
      return GeographicLevel.subblock;
    } else if (filterState.selectedWard != null &&
        filterState.selectedWard != 'All') {
      return GeographicLevel.ward;
    } else if (filterState.selectedUnion != null &&
        filterState.selectedUnion != 'All') {
      return GeographicLevel.union;
    } else if (filterState.selectedUpazila != null &&
        filterState.selectedUpazila != 'All') {
      return GeographicLevel.upazila;
    } else if (filterState.selectedDistrict != null &&
        filterState.selectedDistrict != 'All') {
      return GeographicLevel.district;
    } else if (filterState.selectedDivision != 'All') {
      return GeographicLevel.division;
    } else if (filterState.selectedAreaType == AreaType.cityCorporation) {
      if (filterState.selectedZone != null &&
          filterState.selectedZone != 'All') {
        return GeographicLevel.zone;
      } else if (filterState.selectedCityCorporation != null &&
          filterState.selectedCityCorporation != 'All') {
        return GeographicLevel.cityCorporation;
      }
    }
    return GeographicLevel.country;
  }

  /// Handle polygon tap for drilldown
  void _onPolygonTap(LatLng tappedPoint, List<AreaPolygon> areaPolygons) {
    logg.i("Session Plan: Map tapped at: ${tappedPoint.latitude}, ${tappedPoint.longitude}");

    // Find which polygon was tapped
    AreaPolygon? tappedPolygon;
    for (final areaPolygon in areaPolygons) {
      if (isTappedPointInPolygon(tappedPoint, areaPolygon.polygon.points)) {
        tappedPolygon = areaPolygon;
        break;
      }
    }

    if (tappedPolygon != null) {
      logg.i("Session Plan: Tapped on: ${tappedPolygon.areaName}");

      if (tappedPolygon.canDrillDown && tappedPolygon.slug != null) {
        logg.i("Session Plan: Drilling down to: ${tappedPolygon.areaName}");
        _performDrillDown(tappedPolygon);
      } else {
        logg.i(
          "Session Plan: Cannot drill down to ${tappedPolygon.areaName} - no detailed data available",
        );
        showCustomSnackBar(
          context: context,
          message: 'No more detailed map available',
          color: Colors.blueGrey.shade600,
        );
      }
    } else {
      logg.i("Session Plan: No polygon found at tapped location");
    }
  }

  /// Ensure EPI data is loaded for the filtered area (called when only dates change)
  /// This logs a warning if EPI data doesn't match the filter level
  Future<void> _ensureEpiDataForFilteredArea(FilterState filterState, WidgetRef ref) async {
    try {
      final mapState = ref.read(mapControllerProvider);
      final filterNotifier = ref.read(filterControllerProvider.notifier);
      
      // Determine the filter level
      GeographicLevel? filterLevel;
      String? epiSlug;
      
      // Check from deepest to shallowest level
      if (filterState.selectedSubblock != null && filterState.selectedSubblock != 'All') {
        // Build concatenated slug for subblock
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        final wardUid = filterNotifier.getWardUid(filterState.selectedWard!);
        final subblockUid = filterNotifier.getSubblockUid(filterState.selectedSubblock!);
        if (districtUid != null && upazilaUid != null && unionUid != null && wardUid != null && subblockUid != null) {
          epiSlug = '$districtUid/$upazilaUid/$unionUid/$wardUid/$subblockUid';
          filterLevel = GeographicLevel.subblock;
        }
      } else if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        final wardUid = filterNotifier.getWardUid(filterState.selectedWard!);
        if (districtUid != null && upazilaUid != null && unionUid != null && wardUid != null) {
          epiSlug = '$districtUid/$upazilaUid/$unionUid/$wardUid';
          filterLevel = GeographicLevel.ward;
        }
      } else if (filterState.selectedUnion != null && filterState.selectedUnion != 'All') {
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        final unionUid = filterNotifier.getUnionUid(filterState.selectedUnion!);
        if (districtUid != null && upazilaUid != null && unionUid != null) {
          epiSlug = '$districtUid/$upazilaUid/$unionUid';
          filterLevel = GeographicLevel.union;
        }
      } else if (filterState.selectedUpazila != null && filterState.selectedUpazila != 'All') {
        final districtUid = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        final upazilaUid = filterNotifier.getUpazilaUid(filterState.selectedUpazila!);
        if (districtUid != null && upazilaUid != null) {
          epiSlug = '$districtUid/$upazilaUid';
          filterLevel = GeographicLevel.upazila;
        }
      } else if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
        epiSlug = filterNotifier.getDistrictUid(filterState.selectedDistrict!);
        filterLevel = GeographicLevel.district;
      } else if (filterState.selectedDivision != null && filterState.selectedDivision != 'All') {
        epiSlug = filterNotifier.getDivisionUid(filterState.selectedDivision);
        filterLevel = GeographicLevel.division;
      } else if (filterState.selectedAreaType == AreaType.cityCorporation) {
        if (filterState.selectedZone != null && filterState.selectedZone != 'All') {
          final ccUid = filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation!);
          final zoneUid = filterNotifier.getZoneUid(filterState.selectedZone!);
          if (ccUid != null && zoneUid != null) {
            epiSlug = '$ccUid/$zoneUid';
            filterLevel = GeographicLevel.zone;
          }
        } else if (filterState.selectedCityCorporation != null && filterState.selectedCityCorporation != 'All') {
          epiSlug = filterNotifier.getCityCorporationUid(filterState.selectedCityCorporation!);
          filterLevel = GeographicLevel.cityCorporation;
        }
      }
      
      // If no geographic filter is applied, use country level (null slug)
      if (filterLevel == null) {
        filterLevel = GeographicLevel.country;
        epiSlug = null;
      }
      
      // Check if EPI data matches the filter level
      if (mapState.currentLevel != filterLevel) {
        logg.w("Session Plan: ⚠️ EPI data level mismatch - map: ${mapState.currentLevel.value}, filter: ${filterLevel.value}");
        logg.w("Session Plan: EPI count may be incorrect. Geographic filters should trigger map drilldown to load correct EPI data.");
      } else if (mapState.epiCenterCoordsData == null) {
        logg.w("Session Plan: ⚠️ EPI data is null for filter level: ${filterLevel.value}");
      } else {
        logg.i("Session Plan: ✅ EPI data matches filter level (${filterLevel.value}) - ${mapState.epiCenterCoordsData!.features?.length ?? 0} EPI centers");
      }
    } catch (e) {
      logg.w("Session Plan: Error ensuring EPI data for filtered area: $e");
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
      logg.w("Session Plan: Cannot drill down further from ${currentLevel.value}");
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

    // ✅ FIX: Reload session plan data after drilldown completes
    // Wait for map controller to finish loading
    Future.delayed(const Duration(milliseconds: 500), () async {
      int retries = 0;
      const maxRetries = 50; // 5 seconds max wait
      
      while (retries < maxRetries && mounted) {
        final currentMapState = ref.read(mapControllerProvider);
        if (!currentMapState.isLoading) {
          logg.i("Session Plan: Map controller finished loading after drilldown, reloading session plan data");
          if (mounted) {
            ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
          }
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
        retries++;
      }
    });
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
      // Too many areas for name markers, skipping labels
      return [];
    }

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

  @override
  Widget build(BuildContext context) {
    final sessionPlanState = ref.watch(sessionPlanControllerProvider);
    final mapState = ref.watch(mapControllerProvider);
    
    // ✅ FIX: Track marker building state
    // If we have data but no markers yet, we're building markers
    // This helps show loading indicator during the gap when markers are being built
    final hasData = sessionPlanState.sessionPlanCoordsData != null;
    
    // Check if markers are already built for current data
    final markersBuilt = _cachedMarkers != null && 
                         _cachedMarkerData == sessionPlanState.sessionPlanCoordsData &&
                         _cachedMarkers!.isNotEmpty;
    
    // Only show "building markers" if we have data, markers aren't built yet, and we're not loading data
    // Also check the flag to ensure we're actually in the process of building
    final isBuildingMarkers = hasData && 
                              !markersBuilt && 
                              !sessionPlanState.isLoading &&
                              _isCurrentlyBuildingMarkers;

    // ✅ Listen to filter state changes and reload session plan data + trigger map drilldown
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Session Plan: Filter applied - reloading session plan data and triggering map drilldown");
        
        // Check if only vaccine changed (no geographic filter changes)
        final bool onlyVaccineChanged =
            previous.selectedAreaType == current.selectedAreaType &&
            previous.selectedDivision == current.selectedDivision &&
            previous.selectedDistrict == current.selectedDistrict &&
            previous.selectedCityCorporation == current.selectedCityCorporation &&
            previous.selectedUpazila == current.selectedUpazila &&
            previous.selectedUnion == current.selectedUnion &&
            previous.selectedWard == current.selectedWard &&
            previous.selectedSubblock == current.selectedSubblock &&
            previous.selectedZone == current.selectedZone &&
            previous.selectedYear == current.selectedYear &&
            previous.selectedVaccine != current.selectedVaccine;

        if (onlyVaccineChanged) {
          // Only reload session plan data, don't trigger map drilldown
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
            }
          });
          return;
        }

        // ✅ OPTIMIZATION 4: Check if only dates changed (no geographic or other filter changes)
        // Note: Dates are stored in session plan state, not filter state
        // We detect date-only changes by checking if all geographic filters are unchanged
        // The actual date comparison happens in the session plan controller
        final bool onlyDatesOrNonGeographicChanged =
            previous.selectedAreaType == current.selectedAreaType &&
            previous.selectedDivision == current.selectedDivision &&
            previous.selectedDistrict == current.selectedDistrict &&
            previous.selectedCityCorporation == current.selectedCityCorporation &&
            previous.selectedUpazila == current.selectedUpazila &&
            previous.selectedUnion == current.selectedUnion &&
            previous.selectedWard == current.selectedWard &&
            previous.selectedSubblock == current.selectedSubblock &&
            previous.selectedZone == current.selectedZone &&
            previous.selectedYear == current.selectedYear &&
            previous.selectedVaccine == current.selectedVaccine;
        
        // If only non-geographic filters changed (dates, vaccine, etc.), skip map drilldown
        if (onlyDatesOrNonGeographicChanged) {
          // Only reload session plan data, skip map drilldown (saves 1-3 seconds)
          logg.i("Session Plan: ✅ Only non-geographic filters changed (dates/vaccine) - skipping map drilldown");
          
          // ✅ FIX: Ensure EPI data is loaded for the current filter level
          // Even when only dates change, we need to make sure EPI data matches the filtered area
          _ensureEpiDataForFilteredArea(current, ref);
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
            }
          });
          return;
        }

        // Detect deepest hierarchical selection for drilldown
        final bool subblockFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedWard != null &&
            current.selectedSubblock != null &&
            current.selectedSubblock != 'All';
        final bool wardFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedWard != null &&
            current.selectedWard != 'All' &&
            (current.selectedSubblock == null || current.selectedSubblock == 'All');
        final bool unionFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedUpazila != null &&
            current.selectedUnion != null &&
            current.selectedUnion != 'All' &&
            (current.selectedWard == null || current.selectedWard == 'All');
        final bool upazilaFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedDistrict != 'All' &&
            current.selectedUpazila != null &&
            current.selectedUpazila != 'All' &&
            (current.selectedUnion == null || current.selectedUnion == 'All');
        final bool districtFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDistrict != null &&
            current.selectedDistrict != 'All' &&
            (current.selectedUpazila == null || current.selectedUpazila == 'All');
        final bool divisionFilterApplied =
            current.selectedAreaType == AreaType.district &&
            current.selectedDivision != 'All' &&
            current.selectedDistrict == null &&
            current.selectedUpazila == null;
        final bool zoneFilterApplied =
            current.selectedAreaType == AreaType.cityCorporation &&
            current.selectedCityCorporation != null &&
            current.selectedZone != null &&
            current.selectedZone != 'All';
        final bool cityCorporationFilterApplied =
            current.selectedAreaType == AreaType.cityCorporation &&
            current.selectedCityCorporation != null &&
            (current.selectedZone == null || current.selectedZone == 'All');
        final bool shouldResetToCountry =
            current.selectedAreaType == AreaType.district &&
            current.selectedDivision == 'All' &&
            current.selectedDistrict == null &&
            current.selectedUpazila == null &&
            current.selectedUnion == null &&
            current.selectedWard == null &&
            current.selectedSubblock == null;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;

          final mapNotifier = ref.read(mapControllerProvider.notifier);
          bool drilldownTriggered = false;

          // Trigger map drilldown based on deepest selection (check from deepest to shallowest)
          if (subblockFilterApplied) {
            logg.i("Session Plan: Triggering subblock drilldown: ${current.selectedSubblock}");
            // Note: Subblock drilldown would need to be implemented if needed
            // For now, fall through to ward level
          } else if (wardFilterApplied) {
            logg.i("Session Plan: Triggering ward drilldown: ${current.selectedWard}");
            await mapNotifier.loadWardData(wardName: current.selectedWard!);
            drilldownTriggered = true;
          } else if (unionFilterApplied) {
            logg.i("Session Plan: Triggering union drilldown: ${current.selectedUnion}");
            await mapNotifier.loadUnionData(unionName: current.selectedUnion!);
            drilldownTriggered = true;
          } else if (upazilaFilterApplied) {
            logg.i("Session Plan: Triggering upazila drilldown: ${current.selectedUpazila}");
            try {
              // ✅ FIX: Wait for upazilas to load before calling loadUpazilaData
              if (current.upazilas.isEmpty) {
                logg.w("Session Plan: Upazilas list is empty, waiting for them to load...");
                int retries = 0;
                const maxRetries = 30; // 3 seconds max wait
                
                while (retries < maxRetries && mounted) {
                  await Future.delayed(const Duration(milliseconds: 100));
                  final updatedFilterState = ref.read(filterControllerProvider);
                  if (updatedFilterState.upazilas.isNotEmpty) {
                    logg.i("Session Plan: Upazilas loaded (${updatedFilterState.upazilas.length} items), proceeding with drilldown");
                    break;
                  }
                  retries++;
                }
                
                final finalFilterState = ref.read(filterControllerProvider);
                if (finalFilterState.upazilas.isEmpty) {
                  logg.e("Session Plan: Upazilas still not loaded after waiting - proceeding anyway");
                }
              }
              
              await mapNotifier.loadUpazilaData(upazilaName: current.selectedUpazila!);
              drilldownTriggered = true;
            } catch (e) {
              logg.e("Session Plan: Failed to load upazila data: $e");
              // Continue with session plan data load even if map drilldown fails
              drilldownTriggered = false;
            }
          } else if (districtFilterApplied) {
            logg.i("Session Plan: Triggering district drilldown: ${current.selectedDistrict}");
            await mapNotifier.loadDistrictData(districtName: current.selectedDistrict!);
            drilldownTriggered = true;
          } else if (divisionFilterApplied) {
            logg.i("Session Plan: Triggering division drilldown: ${current.selectedDivision}");
            await mapNotifier.loadDivisionData(divisionName: current.selectedDivision);
            drilldownTriggered = true;
          } else if (zoneFilterApplied) {
            logg.i("Session Plan: Triggering zone drilldown: ${current.selectedZone} in ${current.selectedCityCorporation}");
            await mapNotifier.loadZoneData(zoneName: current.selectedZone!);
            drilldownTriggered = true;
          } else if (cityCorporationFilterApplied) {
            logg.i("Session Plan: Triggering city corporation drilldown: ${current.selectedCityCorporation}");
            await mapNotifier.loadCityCorporationData(
              cityCorporationName: current.selectedCityCorporation!,
            );
            drilldownTriggered = true;
          } else if (shouldResetToCountry) {
            logg.i("Session Plan: Resetting to country view");
            await mapNotifier.resetToCountryLevel();
            drilldownTriggered = true;
          }

          // ✅ FIX: Wait for map controller to finish loading after drilldown
          // Poll until map controller finishes loading or timeout
          if (drilldownTriggered) {
            int retries = 0;
            const maxRetries = 50; // 5 seconds max wait (50 * 100ms)
            
            while (retries < maxRetries && mounted) {
              final currentMapState = ref.read(mapControllerProvider);
              if (!currentMapState.isLoading) {
                // Map controller finished loading (with or without GeoJSON)
                logg.i("Session Plan: Map controller finished loading (GeoJSON: ${currentMapState.areaCoordsGeoJsonData != null}), proceeding with session plan data load");
                break;
              }
              await Future.delayed(const Duration(milliseconds: 100));
              retries++;
            }
          }

          // Reload session plan data after map drilldown completes (or immediately if no drilldown)
          if (mounted) {
            ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
          }
        });
      }
    });

    // ✅ Listen to map controller state changes to trigger auto-zoom after drilldown
    ref.listen<dynamic>(mapControllerProvider, (previous, current) {
      // Check if map controller just finished loading after drilldown
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          current.areaCoordsGeoJsonData != null) {
        // Throttle auto-zoom to prevent rapid calls
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 800) {
          logg.i("Session Plan: Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer
        _autoZoomTimer?.cancel();

        // Schedule auto-zoom after tiles load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            if (mounted && current.areaCoordsGeoJsonData != null) {
              // Parse fresh polygons for auto-zoom from map controller
              final freshPolygons = parseGeoJsonToPolygonsSimple(
                current.areaCoordsGeoJsonData!,
              );

              if (freshPolygons.isNotEmpty) {
                logg.i(
                  "Session Plan: Auto-zooming to ${freshPolygons.length} polygons from map controller",
                );
                _autoZoomToPolygons(freshPolygons);
              } else {
                logg.w("Session Plan: No polygons available for auto-zoom");
              }
            }
          } catch (e) {
            logg.w("Session Plan: Auto-zoom failed: $e");
          }
        });
      }
    });

    // ✅ Also listen to session plan state changes (fallback if map controller doesn't have GeoJSON)
    ref.listen<SessionPlanState>(sessionPlanControllerProvider, (previous, current) {
      // ✅ Clear cache when data changes
      if (previous?.sessionPlanCoordsData != current.sessionPlanCoordsData) {
        _cachedMarkers = null;
        _cachedMarkerData = null;
      }
      
      // Only trigger auto-zoom if map controller doesn't have GeoJSON
      final mapState = ref.read(mapControllerProvider);
      if (mapState.areaCoordsGeoJsonData != null) {
        // Map controller has GeoJSON, skip session plan auto-zoom
        return;
      }

      // Check if we just finished loading after a filter application
      if (previous?.isLoading == true &&
          current.isLoading == false &&
          current.error == null &&
          current.areaCoordsGeoJsonData != null) {
        // Throttle auto-zoom to prevent rapid calls
        final now = DateTime.now();
        if (_lastAutoZoom != null &&
            now.difference(_lastAutoZoom!).inMilliseconds < 800) {
          logg.i("Session Plan: Auto-zoom throttled - too recent");
          return;
        }
        _lastAutoZoom = now;

        // Cancel any existing timer
        _autoZoomTimer?.cancel();

        // Schedule auto-zoom after tiles load
        _autoZoomTimer = Timer(const Duration(milliseconds: 1500), () {
          try {
            if (mounted && current.areaCoordsGeoJsonData != null) {
              // Parse fresh polygons for auto-zoom from session plan
              final freshPolygons = parseGeoJsonToPolygonsSimple(
                current.areaCoordsGeoJsonData!,
              );

              if (freshPolygons.isNotEmpty) {
                logg.i(
                  "Session Plan: Auto-zooming to ${freshPolygons.length} polygons from session plan",
                );
                _autoZoomToPolygons(freshPolygons);
              } else {
                logg.w("Session Plan: No polygons available for auto-zoom");
              }
            }
          } catch (e) {
            logg.w("Session Plan: Auto-zoom failed: $e");
          }
        });
      }
    });

    // ✅ FIX: Use map controller's GeoJSON if available (from drilldown), otherwise use session plan's GeoJSON
    // This ensures we show the correct drilldown polygons
    List<AreaPolygon> areaPolygons = [];
    final geoJsonData = mapState.areaCoordsGeoJsonData ?? sessionPlanState.areaCoordsGeoJsonData;
    if (geoJsonData != null) {
      final rawPolygons = parseGeoJsonToPolygonsSimple(geoJsonData);
      
      // ✅ FIX: Determine drilldown capability based on current geographic level
      final filterState = ref.read(filterControllerProvider);
      final currentLevel = _getCurrentGeographicLevel(filterState);
      final nextLevel = currentLevel.nextLevel;
      
      // Update canDrillDown for each polygon based on current level
      if (nextLevel != null) {
        areaPolygons = rawPolygons.map((polygon) {
          // Enable drilldown if we have a slug and next level is available
          if (polygon.slug != null && polygon.slug!.isNotEmpty) {
            // Create a new polygon with canDrillDown enabled
            return AreaPolygon(
              polygon: polygon.polygon,
              areaId: polygon.areaId,
              areaName: polygon.areaName,
              level: polygon.level,
              coveragePercentage: polygon.coveragePercentage,
              slug: polygon.slug,
              parentSlug: polygon.parentSlug,
              canDrillDown: true, // Enable drilldown
              orgUid: polygon.orgUid,
            );
          }
          return polygon;
        }).toList();
      } else {
        areaPolygons = rawPolygons;
      }
      
      logg.i("Session Plan: Using ${mapState.areaCoordsGeoJsonData != null ? 'map controller' : 'session plan'} GeoJSON data (${areaPolygons.length} polygons, currentLevel: ${currentLevel.value}, nextLevel: ${nextLevel?.value ?? 'none'})");
    }

    // Auto-zoom if markers are available?
    // For now we stick to country view unless user wants specific behavior,
    // but the MapScreen logic to auto-zoom to polygon bounds is good.
    // However, since we are showing country map initially, default zoom is fine.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Session Plans',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // ✅ Add filter button to AppBar
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ Show map immediately (even during loading) for better UX
          // This prevents the empty screen issue where users see nothing
          if (sessionPlanState.areaCoordsGeoJsonData != null ||
              sessionPlanState.sessionPlanCoordsData != null ||
              sessionPlanState.isLoading)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(23.6850, 90.3563),
                initialZoom: _initialZoom,
                minZoom: 3.5,
                maxZoom: 18.0,
                onTap: (tapPosition, point) {
                  _onPolygonTap(point, areaPolygons);
                },
              ),
              children: [
                MapTileLayer(),
                // Only show polygons if GeoJSON data is available
                if (areaPolygons.isNotEmpty)
                  PolygonLayer(
                    polygons: areaPolygons.map((e) => e.polygon).toList(),
                  ),
                // Always show markers if session plan data is available
                if (sessionPlanState.sessionPlanCoordsData != null)
                  Builder(
                    builder: (context) {
                      final markers = _buildSessionPlanMarkers(
                        sessionPlanState.sessionPlanCoordsData!,
                      );
                      // ✅ FIX: Trigger rebuild after markers are built to hide loading indicator
                      if (_isCurrentlyBuildingMarkers && markers.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _isCurrentlyBuildingMarkers = false;
                            });
                          }
                        });
                      }
                      return MarkerLayer(markers: markers);
                    },
                  ),
                // Area name labels - Show for all levels except country level
                if (areaPolygons.isNotEmpty) ...[
                  Builder(
                    builder: (context) {
                      final filterState = ref.read(filterControllerProvider);
                      final currentLevel = _getCurrentGeographicLevel(filterState);
                      if (currentLevel.shouldShowAreaLabels) {
                        return MarkerLayer(
                          markers: _buildAreaNameMarkers(areaPolygons),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),

          // ✅ Show loading overlay on top of map during loading OR marker building
          if (sessionPlanState.isLoading || isBuildingMarkers)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomLoadingWidget(
                    loadingText: sessionPlanState.isLoading 
                        ? 'Loading session plans...' 
                        : 'Building markers...',
                  ),
                ),
              ),
            ),

          // ✅ Improved error display
          if (sessionPlanState.error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      sessionPlanState.error!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
