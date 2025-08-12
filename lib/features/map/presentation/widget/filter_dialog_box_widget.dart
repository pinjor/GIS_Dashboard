// 📁 widgets/filter_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/providers/filter_provider.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

class FilterDialogBoxWidget extends ConsumerStatefulWidget {
  const FilterDialogBoxWidget({super.key});

  @override
  ConsumerState<FilterDialogBoxWidget> createState() =>
      _FilterDialogBoxWidgetState();
}

class _FilterDialogBoxWidgetState extends ConsumerState<FilterDialogBoxWidget> {
  // Local state for temporary selections (until user clicks Filter)
  late String _selectedAreaType;
  late String _selectedVaccine;
  late String _selectedDivision;
  String? _selectedCityCorporation;

  final _formKey = GlobalKey<FormState>();

  // Bangladesh Divisions
  final List<String> _divisions = [
    'All',
    'Dhaka Division',
    'Barishal Division',
    'Rajshahi Division',
    'Rangpur Division',
    'Sylhet Division',
    // 'Chattogram Division',
    // 'Khulna Division',
    // 'Mymensingh Division',
  ];

  // Bangladesh City Corporations
  final List<String> _cityCorporations = [
    'Dhaka North CC',
    'Dhaka South CC',
    'Gazipur CC',
    'Narayanganj CC',
    'Chattogram CC',
    'Khulna CC',
    'Sylhet CC',
    'Rangpur CC',
    // 'Rajshahi CC',
    // 'Barishal CC',
    // 'Cumilla CC',
    // 'Mymensingh CC',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current filter state - will be set on first build
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize with current filter state
    final currentFilter = ref.read(filterProvider);
    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedVaccine = currentFilter.selectedVaccine;
    _selectedDivision = currentFilter.selectedDivision;
    _selectedCityCorporation = currentFilter.selectedCityCorporation;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(Constants.primaryColor);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Material(
            color: Color(Constants.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.h,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAreaType = 'district';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: primaryColor,
                            value: 'district',
                            groupValue: _selectedAreaType,
                            onChanged: (value) {
                              setState(() {
                                _selectedAreaType = value!;
                              });
                            },
                          ),
                          const Text('District'),
                        ],
                      ),
                    ),
                    12.w,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAreaType = 'city_corporation';
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,

                            activeColor: primaryColor,
                            value: 'city_corporation',
                            groupValue: _selectedAreaType,
                            onChanged: (value) {
                              setState(() {
                                _selectedAreaType = value!;
                              });
                            },
                          ),
                          const Text('City Corporation'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Period',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                8.h,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: '2025',
                  items: ['2025', '2024']
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
                16.h,
                if (_selectedAreaType == 'district') ...[
                  const Text(
                    'Division',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDivision,
                    items: _divisions
                        .map(
                          (division) => DropdownMenuItem(
                            value: division,
                            child: Text(division),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDivision = value!;
                      });
                    },
                  ),
                  16.h,
                  const Text(
                    'District',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search District',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ] else if (_selectedAreaType == 'city_corporation') ...[
                  const Text(
                    'City Corporation',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  8.h,
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCityCorporation,
                    hint: const Text('Select City Corporation'),
                    items: _cityCorporations
                        .map(
                          (corporation) => DropdownMenuItem(
                            value: corporation,
                            child: Text(corporation),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCityCorporation = value;
                      });
                    },
                  ),
                ],
                16.h,
                const Text(
                  'Select Vaccine',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                8.h,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          _buildRadio('Penta - 1st', primaryColor),
                          _buildRadio('Penta - 2nd', primaryColor),
                          _buildRadio('Penta - 3rd', primaryColor),
                        ],
                      ),
                    ),
                    // Second column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          _buildRadio('MR - 1st', primaryColor),
                          _buildRadio('MR - 2nd', primaryColor),
                          _buildRadio('BCG', primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),
                24.h,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ), // Makes it perfectly square
                          ),
                        ),

                        onPressed: () {
                          // Apply filters to global state
                          ref
                              .read(filterProvider.notifier)
                              .updateVaccine(_selectedVaccine);
                          // ref
                          //     .read(filterProvider.notifier)
                          //     .updateAreaType(_selectedAreaType);
                          // ref
                          //     .read(filterProvider.notifier)
                          //     .updateDivision(_selectedDivision);
                          // ref
                          //     .read(filterProvider.notifier)
                          //     .updateCityCorporation(_selectedCityCorporation);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    8.w,
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ), // Makes it perfectly square
                          ),
                        ),
                        onPressed: () {
                          // Reset filters to default
                          ref.read(filterProvider.notifier).resetFilters();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String label, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVaccine = label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            activeColor: primaryColor,
            value: label,
            groupValue: _selectedVaccine,
            onChanged: (value) {
              setState(() {
                _selectedVaccine = value!;
              });
            },
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
