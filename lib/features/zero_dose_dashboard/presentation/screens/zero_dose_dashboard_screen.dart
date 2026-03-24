import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/enums/vaccine_type.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../summary/presentation/controllers/summary_controller.dart';
import '../../../summary/domain/vaccine_coverage_response.dart';
import '../../../filter/filter.dart';
import '../../../map/presentation/screen/map_screen.dart';
import '../../../map/presentation/controllers/map_controller.dart';
import '../widgets/zero_dose_bar_chart_widget.dart';

class ZeroDoseDashboardScreen extends ConsumerStatefulWidget {
  const ZeroDoseDashboardScreen({super.key});

  @override
  ConsumerState<ZeroDoseDashboardScreen> createState() =>
      _ZeroDoseDashboardScreenState();
}

class _ZeroDoseDashboardScreenState
    extends ConsumerState<ZeroDoseDashboardScreen> {

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Color(Constants.cardColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: const FilterDialogBoxWidget(
          isEpiContext: false,
          hideSubblock: true, // Hide subblock field in Zero Dose Dashboard
        ),
      ),
    );
  }

  String _getLocationName(String locationName) {
    if (locationName.isEmpty) return 'Bangladesh';
    return locationName.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryControllerProvider);
    final coverageData = summaryState.coverageData;
    final locationName = _getLocationName(summaryState.currentAreaName);

    // Extract Penta-1 vaccine data and calculate top 5 zero dose areas
    List<Area> topZeroDoseAreas = [];

    if (coverageData?.vaccines != null) {
      // Find Penta-1 vaccine
      final pentaVaccine = coverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      if (pentaVaccine.areas != null && pentaVaccine.areas!.isNotEmpty) {
        // Calculate zero dose count for each area
        final areasWithZeroDose = pentaVaccine.areas!.map((area) {
          return area;
        }).toList();

        // Sort by zero dose count (target - coverage) in descending order
        // ✅ Allow negative values - they show areas where coverage exceeded target
        areasWithZeroDose.sort((a, b) {
          final zeroDoseA = (a.target ?? 0) - (a.coverage ?? 0);
          final zeroDoseB = (b.target ?? 0) - (b.coverage ?? 0);
          return zeroDoseB.compareTo(zeroDoseA);
        });

        // Take top 5
        topZeroDoseAreas = areasWithZeroDose.take(5).toList();
      }
    }

    // ✅ Watch map controller and filter state to track changes
    final mapState = ref.watch(mapControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

    // ✅ Listen to filter state changes - data will automatically update via summary controller
    // Also ensure map controller is aware of filter changes (it listens independently)
    ref.listen<FilterState>(filterControllerProvider, (previous, current) {
      if (previous != null &&
          current.lastAppliedTimestamp != null &&
          previous.lastAppliedTimestamp != current.lastAppliedTimestamp) {
        logg.i("Zero Dose Dashboard: Filter applied - data will update via summary controller");
        logg.i("Zero Dose Dashboard: Map will reflect new filters when opened");
        logg.i("Zero Dose Dashboard: Current filters - Division: ${current.selectedDivision}, District: ${current.selectedDistrict}, Upazila: ${current.selectedUpazila}");
        
        // ✅ Ensure map controller is aware of filter changes
        // The map controller has its own listener, but we can trigger a refresh if needed
        // when user opens the map, it will automatically use the current filter state
        if (!mapState.isLoading) {
          logg.i("Zero Dose Dashboard: Map controller is ready - filters will be applied when map is opened");
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text(
          'Zero Dose Dashboard',
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
      body: summaryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : summaryState.error != null
          ? Center(
              child: Text(
                'Error: ${summaryState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : topZeroDoseAreas.isEmpty
          ? const Center(
              child: Text(
                'No Penta-1 data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Total Zero Dose Children summary card
                _buildTotalZeroDoseCard(coverageData),
                
                // Bar chart showing top 5 zero dose areas
                Expanded(
                  child: ZeroDoseBarChartWidget(
                    topAreas: topZeroDoseAreas,
                    locationName: locationName,
                    filterState: ref.read(filterControllerProvider),
                  ),
                ),

                // Map visualization section - shows current filter status and links to map
                Container(
                  height: 300,
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        // Map header with filter status
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.map, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Zero Dose Coverage Map',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Navigate to full map button
                                  TextButton.icon(
                                    onPressed: () {
                                      // Navigate to map screen - it will automatically use current filters
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MapScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.open_in_new, size: 16),
                                    label: const Text('View Full Map'),
                                  ),
                                ],
                              ),
                              // ✅ Filter status indicator
                              const SizedBox(height: 8),
                              _buildFilterStatusIndicator(filterState),
                            ],
                          ),
                        ),
                        // Map placeholder with filter-aware message
                        Expanded(
                          child: Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ✅ Show map loading state if map is loading
                                  if (mapState.isLoading)
                                    Column(
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Map is updating with new filters...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.map_outlined,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Map reflects current filters',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Map automatically reflects current filters',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Open map to see coverage visualization',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const MapScreen(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.map, size: 18),
                                          label: const Text('Open Map'),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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

  /// Build the total zero dose children summary card
  Widget _buildTotalZeroDoseCard(VaccineCoverageResponse? coverageData) {
    int totalZeroDoseCount = 0;

    if (coverageData?.vaccines != null) {
      // Find Penta-1 vaccine
      final pentaVaccine = coverageData!.vaccines!.firstWhere(
        (vaccine) => vaccine.vaccineUid == VaccineType.penta1.uid,
        orElse: () => const Vaccine(),
      );

      // Calculate total zero dose: totalTarget - totalCoverage
      // ✅ Allow negative values to show when coverage exceeds target
      if (pentaVaccine.totalTarget != null && pentaVaccine.totalCoverage != null) {
        totalZeroDoseCount = (pentaVaccine.totalTarget ?? 0) - (pentaVaccine.totalCoverage ?? 0);
        // Negative values are allowed - they indicate coverage exceeded target
      }
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3), // Blue color matching the bar chart
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Zero Dose Children',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalZeroDoseCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Icons section
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.child_care,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build filter status indicator showing current active filters
  Widget _buildFilterStatusIndicator(FilterState filterState) {
    final activeFilters = <String>[];
    
    if (filterState.selectedDivision != 'All') {
      activeFilters.add('Division: ${filterState.selectedDivision}');
    }
    if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
      activeFilters.add('District: ${filterState.selectedDistrict}');
    }
    if (filterState.selectedUpazila != null && filterState.selectedUpazila != 'All') {
      activeFilters.add('Upazila: ${filterState.selectedUpazila}');
    }
    if (filterState.selectedUnion != null && filterState.selectedUnion != 'All') {
      activeFilters.add('Union: ${filterState.selectedUnion}');
    }
    if (filterState.selectedWard != null && filterState.selectedWard != 'All') {
      activeFilters.add('Ward: ${filterState.selectedWard}');
    }
    if (filterState.selectedCityCorporation != null && filterState.selectedCityCorporation != 'All') {
      activeFilters.add('CC: ${filterState.selectedCityCorporation}');
    }
    if (filterState.selectedZone != null && filterState.selectedZone != 'All') {
      activeFilters.add('Zone: ${filterState.selectedZone}');
    }
    if (filterState.selectedYear != '2025') {
      activeFilters.add('Year: ${filterState.selectedYear}');
    }

    if (activeFilters.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 14, color: Colors.blue[700]),
            const SizedBox(width: 4),
            Text(
              'Showing country-level data',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt, size: 14, color: Colors.green[700]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              activeFilters.length > 2 
                ? '${activeFilters.take(2).join(', ')} +${activeFilters.length - 2} more'
                : activeFilters.join(', '),
              style: TextStyle(
                fontSize: 11,
                color: Colors.green[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
