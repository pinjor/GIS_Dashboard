import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/constants/constants.dart';
import '../../../../core/common/widgets/custom_loading_widget.dart';
import '../../../../core/common/widgets/network_error_widget.dart';
import '../../../../core/utils/utils.dart';
import '../../../epi_center/presentation/controllers/epi_center_controller.dart';
import '../../../epi_center/presentation/widgets/epi_center_about_details_widget.dart';
import '../../../epi_center/presentation/widgets/epi_center_microplan_widgets.dart';
import '../../../epi_center/presentation/widgets/epi_yearly_session_personnel_widget.dart';
import '../../../filter/presentation/controllers/filter_controller.dart';
import '../../../map/presentation/controllers/map_controller.dart';

class MicroPlanScreen extends ConsumerStatefulWidget {
  const MicroPlanScreen({super.key});

  @override
  ConsumerState<MicroPlanScreen> createState() => _MicroPlanScreenState();
}

class _MicroPlanScreenState extends ConsumerState<MicroPlanScreen> {
  @override
  void initState() {
    super.initState();
    // Load EPI center data when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMicroPlanData();
    });
  }

  Future<void> _loadMicroPlanData() async {
    final mapNotifier = ref.read(mapControllerProvider.notifier);
    final filterState = ref.read(filterControllerProvider);
    final epiController = ref.read(epiCenterControllerProvider.notifier);

    final orgUid = mapNotifier.focalAreaUid;
    final year = filterState.selectedYear;

    logg.i("🔄 Loading Micro Plan data");
    logg.i("   > Org UID: $orgUid");
    logg.i("   > Year: $year");
    logg.i("   > Area Type: ${filterState.selectedAreaType}");
    logg.i("   > City Corporation: ${filterState.selectedCityCorporation}");
    logg.i("   > Zone: ${filterState.selectedZone}");

    // ✅ FIX: Use the actual orgUid from focalAreaUid instead of hardcoded 'null'
    // focalAreaUid now properly handles zones and city corporations
    final effectiveUid = (orgUid != null && orgUid.isNotEmpty)
        ? orgUid
        : 'null';

    logg.i("   > Effective UID for API: $effectiveUid");

    // Fetch data using the focal area UID (which now includes zone support)
    await epiController.fetchEpiCenterDataByOrgUid(orgUid: effectiveUid, year: year);
  }

  @override
  Widget build(BuildContext context) {
    final epiState = ref.watch(epiCenterControllerProvider);
    final filterState = ref.watch(filterControllerProvider);

    final epiCenterData = epiState.epiCenterData;
    final selectedYear = filterState.selectedYear;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Constants.primaryColor),
        title: const Text('Micro Plan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: epiState.isLoading
          ? const Center(
              child: CustomLoadingWidget(
                loadingText: 'Loading micro plan data...',
              ),
            )
          : epiState.hasError
          ? NetworkErrorWidget(
              error: epiState.errorMessage ?? 'Failed to load data',
              onRetry: _loadMicroPlanData,
            )
          : epiCenterData == null
          ? const Center(
              child: Text(
                'No micro plan data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Microplan section
                  EpiCenterMicroplanSection(
                    epiCenterDetailsData: epiCenterData,
                  ),
                  const SizedBox(height: 24),
                  EpiCenterAboutDetailsWidget(
                    epiCenterDetailsData: epiCenterData,
                    selectedYear: selectedYear,
                  ),
                  const SizedBox(height: 10),
                  EpiYearlySessionPersonnelWidget(
                    epiCenterDetailsData: epiCenterData,
                    selectedYear: selectedYear,
                  ),
                ],
              ),
            ),
    );
  }
}
