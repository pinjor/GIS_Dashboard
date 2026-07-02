import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/filter/presentation/widgets/geographic_filter_form.dart';
import '../controllers/epi_center_finder_controller.dart';

class EpiCenterFinderFilterDialog extends ConsumerStatefulWidget {
  const EpiCenterFinderFilterDialog({
    super.key,
    required this.onApplied,
    required this.onReset,
  });

  final Future<void> Function() onApplied;
  final Future<void> Function() onReset;

  @override
  ConsumerState<EpiCenterFinderFilterDialog> createState() =>
      _EpiCenterFinderFilterDialogState();
}

class _EpiCenterFinderFilterDialogState
    extends ConsumerState<EpiCenterFinderFilterDialog> {
  DateTime? _fromDate;
  DateTime? _toDate;

  late AreaType _initialAreaType;
  late String _initialDivision;
  String? _initialDistrict;
  String? _initialUpazila;
  String? _initialUnion;
  String? _initialWard;
  String? _initialCityCorporation;
  String? _initialZone;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _captureInitialFilterValues();
  }

  void _captureInitialFilterValues() {
    final currentFilter = ref.read(filterControllerProvider);
    _initialAreaType = currentFilter.selectedAreaType;
    _initialDivision = currentFilter.selectedDivision;
    _initialDistrict = currentFilter.selectedDistrict;
    _initialUpazila = currentFilter.selectedUpazila;
    _initialUnion = currentFilter.selectedUnion;
    _initialWard = currentFilter.selectedWard;
    _initialCityCorporation = currentFilter.selectedCityCorporation;
    _initialZone = currentFilter.selectedZone;
  }

  void _initializeDates() {
    final finderState = ref.read(epiCenterFinderControllerProvider);
    final today = DateTime.now();

    _fromDate = finderState.startDate ?? today;
    _toDate = finderState.endDate ?? today;
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fromDate) {
      setState(() => _fromDate = picked);
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _toDate) {
      setState(() => _toDate = picked);
    }
  }

  Future<void> _onGeographicApply(GeographicFilterValues values) async {
    if (_fromDate != null && _toDate != null && _toDate!.isBefore(_fromDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date must be after or equal to start date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(epiCenterFinderControllerProvider.notifier).setDateRange(
          _fromDate!,
          _toDate!,
        );

    applyGeographicFilterToController(
      ref,
      values,
      initialAreaType: _initialAreaType,
      initialDivision: _initialDivision,
      initialDistrict: _initialDistrict,
      initialUpazila: _initialUpazila,
      initialUnion: _initialUnion,
      initialWard: _initialWard,
      initialCityCorporation: _initialCityCorporation,
      initialZone: _initialZone,
    );

    if (mounted) Navigator.of(context).pop();
    await widget.onApplied();
  }

  Future<void> _onGeographicReset() async {
    final today = DateTime.now();
    setState(() {
      _fromDate = today;
      _toDate = today;
    });

    ref.read(epiCenterFinderControllerProvider.notifier).setDateRange(
          today,
          today,
        );
    ref.read(filterControllerProvider.notifier).resetFilters();

    if (mounted) Navigator.of(context).pop();
    await widget.onReset();
  }

  int _getTotalSessions() {
    final finderState = ref.watch(epiCenterFinderControllerProvider);
    if (finderState.isLoading) {
      return finderState.sessionCount ?? finderState.results.length;
    }
    if (finderState.results.isNotEmpty) {
      return finderState.results.length;
    }
    return finderState.sessionCount ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final finderState = ref.watch(epiCenterFinderControllerProvider);
    final totalSessions = _getTotalSessions();
    final formattedCount = totalSessions.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );

    return Dialog(
      backgroundColor: Color(Constants.cardColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(Constants.primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                finderState.isLoading
                    ? 'Loading sessions...'
                    : 'Total Session: $formattedCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Date Range',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectFromDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _fromDate != null
                                  ? DateFormat('MM/dd/yyyy').format(_fromDate!)
                                  : 'Select From Date',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectToDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _toDate != null
                                  ? DateFormat('MM/dd/yyyy').format(_toDate!)
                                  : 'Select To Date',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GeographicFilterForm(
              applyOnSubmit: false,
              onApply: _onGeographicApply,
              onReset: _onGeographicReset,
            ),
          ],
        ),
      ),
    );
  }
}
