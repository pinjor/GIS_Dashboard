import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/features/filter/domain/filter_state.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import 'package:gis_dashboard/features/map/utils/map_enums.dart';

/// Normalized geographic filter values ready to apply to [FilterController].
class GeographicFilterValues {
  final AreaType areaType;
  final String division;
  final String? district;
  final String? upazila;
  final String? union;
  final String? ward;
  final String? cityCorporation;
  final String? zone;

  const GeographicFilterValues({
    required this.areaType,
    required this.division,
    this.district,
    this.upazila,
    this.union,
    this.ward,
    this.cityCorporation,
    this.zone,
  });
}

void applyGeographicFilterToController(
  WidgetRef ref,
  GeographicFilterValues values, {
  required AreaType initialAreaType,
  required String initialDivision,
  String? initialDistrict,
  String? initialUpazila,
  String? initialUnion,
  String? initialWard,
  String? initialCityCorporation,
  String? initialZone,
}) {
  final filterNotifier = ref.read(filterControllerProvider.notifier);
  final currentFilter = ref.read(filterControllerProvider);

  filterNotifier.updateAreaType(values.areaType);
  filterNotifier.updateDivision(values.division);

  if (values.areaType == AreaType.district) {
    filterNotifier.updateDistrict(values.district);
    filterNotifier.updateUpazila(values.upazila);
    filterNotifier.updateUnion(values.union);
    filterNotifier.updateWard(values.ward);
    filterNotifier.updateCityCorporation(null);
    filterNotifier.updateZone(null);
  } else {
    filterNotifier.updateCityCorporation(values.cityCorporation);
    filterNotifier.updateZone(values.zone);
    filterNotifier.updateDistrict(null);
    filterNotifier.updateUpazila(null);
    filterNotifier.updateUnion(null);
    filterNotifier.updateWard(null);
  }

  filterNotifier.applyFiltersWithInitialValues(
    areaType: values.areaType,
    division: values.division,
    district: values.district,
    upazila: values.upazila,
    union: values.union,
    ward: values.ward,
    cityCorporation: values.cityCorporation,
    zone: values.zone,
    initialAreaType: initialAreaType,
    initialDivision: initialDivision,
    initialDistrict: initialDistrict,
    initialUpazila: initialUpazila,
    initialUnion: initialUnion,
    initialWard: initialWard,
    initialCityCorporation: initialCityCorporation,
    initialZone: initialZone,
    initialYear: currentFilter.selectedYear,
    initialVaccine: currentFilter.selectedVaccine,
    initialMonths: currentFilter.selectedMonths,
    forceTimestampUpdate: true,
  );
}

/// Shared geographic filter UI (District / City Corporation hierarchy).
class GeographicFilterForm extends ConsumerStatefulWidget {
  const GeographicFilterForm({
    super.key,
    required this.onApply,
    required this.onReset,
    this.showAreaTypeRadios = true,
    this.applyOnSubmit = true,
  });

  final Future<void> Function(GeographicFilterValues values) onApply;
  final Future<void> Function() onReset;
  final bool showAreaTypeRadios;
  final bool applyOnSubmit;

  @override
  ConsumerState<GeographicFilterForm> createState() =>
      _GeographicFilterFormState();
}

class _GeographicFilterFormState extends ConsumerState<GeographicFilterForm> {
  late AreaType _selectedAreaType;
  late String _selectedDivision;
  String? _selectedCityCorporation;
  String? _selectedDistrict;
  String? _selectedZone;
  String? _selectedUpazila;
  String? _selectedUnion;
  String? _selectedWard;

  late AreaType _initialAreaType;
  late String _initialDivision;
  String? _initialCityCorporation;
  String? _initialDistrict;
  String? _initialZone;
  String? _initialUpazila;
  String? _initialUnion;
  String? _initialWard;

  @override
  void initState() {
    super.initState();
    _initializeFromFilterState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterState = ref.read(filterControllerProvider);
      final filterNotifier = ref.read(filterControllerProvider.notifier);

      if (_selectedUpazila != null &&
          _selectedUpazila != 'Select Upazila' &&
          filterState.unions.isEmpty) {
        final upazilaUid = filterNotifier.getUpazilaUid(_selectedUpazila!);
        if (upazilaUid != null) {
          filterNotifier.loadUnionsByUpazila(upazilaUid).then((_) {
            if (mounted) setState(() {});
          });
        }
      }
    });
  }

  void _initializeFromFilterState() {
    final currentFilter = ref.read(filterControllerProvider);

    _selectedAreaType = currentFilter.selectedAreaType;
    _selectedDivision = currentFilter.selectedDivision;

    _initialAreaType = currentFilter.selectedAreaType;
    _initialDivision = currentFilter.selectedDivision;
    _initialCityCorporation = currentFilter.selectedCityCorporation;
    _initialDistrict = currentFilter.selectedDistrict;
    _initialZone = currentFilter.selectedZone;
    _initialUpazila = currentFilter.selectedUpazila;
    _initialUnion = currentFilter.selectedUnion;
    _initialWard = currentFilter.selectedWard;

    if (_selectedAreaType == AreaType.district) {
      _selectedDistrict = currentFilter.selectedDistrict;
      _selectedUpazila = currentFilter.selectedUpazila;
      _selectedUnion = currentFilter.selectedUnion;
      _selectedWard = currentFilter.selectedWard;
    } else {
      _selectedCityCorporation = currentFilter.selectedCityCorporation;
      _selectedZone = currentFilter.selectedZone;
    }
  }

  GeographicFilterValues _normalizedValues() {
    return GeographicFilterValues(
      areaType: _selectedAreaType,
      division: _selectedDivision,
      district: (_selectedDistrict == null || _selectedDistrict == 'All')
          ? null
          : _selectedDistrict,
      upazila: (_selectedUpazila == null || _selectedUpazila == 'Select Upazila')
          ? null
          : _selectedUpazila,
      union: (_selectedUnion == null || _selectedUnion == 'Select Union')
          ? null
          : _selectedUnion,
      ward: (_selectedWard == null || _selectedWard == 'Select Ward')
          ? null
          : _selectedWard,
      cityCorporation:
          (_selectedCityCorporation == null ||
              _selectedCityCorporation == 'Select City Corporation')
          ? null
          : _selectedCityCorporation,
      zone: (_selectedZone == null || _selectedZone == 'Select Zone')
          ? null
          : _selectedZone,
    );
  }

  bool _validateHierarchy(BuildContext context) {
    if (_selectedAreaType == AreaType.district) {
      if (_selectedUnion != null && _selectedUnion != 'Select Union') {
        if (_selectedDistrict == null || _selectedUpazila == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select District and Upazila before selecting Union',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      }

      if (_selectedWard != null && _selectedWard != 'Select Ward') {
        if (_selectedDistrict == null ||
            _selectedUpazila == null ||
            _selectedUnion == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select District, Upazila, and Union before selecting Ward',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      }

      if (_selectedUpazila != null && _selectedUpazila != 'Select Upazila') {
        if (_selectedDistrict == null || _selectedDistrict == 'All') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select a specific District before selecting Upazila',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      }
    }

    if (_selectedAreaType == AreaType.cityCorporation) {
      if (_selectedZone != null && _selectedZone != 'Select Zone') {
        if (_selectedCityCorporation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select City Corporation before selecting Zone',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _handleApply() async {
    if (!_validateHierarchy(context)) return;
    final values = _normalizedValues();
    if (widget.applyOnSubmit) {
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
    }
    await widget.onApply(values);
  }

  Future<void> _handleReset() async {
    final filterState = ref.read(filterControllerProvider);

    setState(() {
      _selectedAreaType = filterState.selectedAreaType;
      _selectedDivision = 'All';
      _selectedCityCorporation = null;
      _selectedDistrict = null;
      _selectedZone = null;
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedWard = null;
    });

    await widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterControllerProvider);
    final filterNotifier = ref.read(filterControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedUpazila != null &&
          _selectedUpazila != 'Select Upazila' &&
          filterState.unions.isEmpty) {
        final upazilaUid = filterNotifier.getUpazilaUid(_selectedUpazila!);
        if (upazilaUid != null) {
          filterNotifier.loadUnionsByUpazila(upazilaUid).then((_) {
            if (mounted) setState(() {});
          });
        }
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showAreaTypeRadios) ...[
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAreaType = AreaType.district;
                      _selectedCityCorporation = null;
                      _selectedZone = null;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<AreaType>(
                        value: AreaType.district,
                        groupValue: _selectedAreaType,
                        onChanged: (value) {
                          setState(() {
                            _selectedAreaType = value!;
                            _selectedCityCorporation = null;
                            _selectedZone = null;
                          });
                        },
                      ),
                      const Flexible(
                        child: Text(
                          'District',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAreaType = AreaType.cityCorporation;
                      _selectedDistrict = null;
                      _selectedUpazila = null;
                      _selectedUnion = null;
                      _selectedWard = null;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<AreaType>(
                        value: AreaType.cityCorporation,
                        groupValue: _selectedAreaType,
                        onChanged: (value) {
                          setState(() {
                            _selectedAreaType = value!;
                            _selectedDistrict = null;
                            _selectedUpazila = null;
                            _selectedUnion = null;
                            _selectedWard = null;
                          });
                        },
                      ),
                      const Flexible(
                        child: Text(
                          'City Corporation',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        if (_selectedAreaType == AreaType.district) ...[
          _buildDropdown(
            label: 'Division',
            value: _selectedDivision,
            items: _buildDivisionItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedDivision = value ?? 'All';
                _selectedDistrict = null;
                _selectedUpazila = null;
                _selectedUnion = null;
                _selectedWard = null;
              });
              if (value != null && value != 'All') {
                filterNotifier.updateDivision(value);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'District',
            value: _selectedDistrict ?? 'All',
            items: _buildDistrictItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value == 'All' ? null : value;
                _selectedUpazila = null;
                _selectedUnion = null;
                _selectedWard = null;
              });
              if (value != null && value != 'All') {
                filterNotifier.updateDistrict(value);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Upazila',
            value: _selectedUpazila ?? 'Select Upazila',
            items: _buildUpazilaItems(filterState),
            onChanged: (value) async {
              setState(() {
                _selectedUpazila = value == 'Select Upazila' ? null : value;
                _selectedUnion = null;
                _selectedWard = null;
              });
              if (value != null && value != 'Select Upazila') {
                filterNotifier.updateUpazila(value);
                final upazilaUid = filterNotifier.getUpazilaUid(value);
                if (upazilaUid != null) {
                  await filterNotifier.loadUnionsByUpazila(upazilaUid);
                  if (mounted) setState(() {});
                }
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Union',
            value: _selectedUnion ?? 'Select Union',
            items: _buildUnionItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedUnion = value == 'Select Union' ? null : value;
                _selectedWard = null;
              });
              if (value != null && value != 'Select Union') {
                filterNotifier.updateUnion(value);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Ward',
            value: _selectedWard ?? 'Select Ward',
            items: _buildWardItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedWard = value == 'Select Ward' ? null : value;
              });
              if (value != null && value != 'Select Ward') {
                filterNotifier.updateWard(value);
              }
            },
          ),
        ] else ...[
          _buildDropdown(
            label: 'City Corporation',
            value: _selectedCityCorporation ?? 'All',
            items: _buildCityCorporationItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedCityCorporation = value == 'All' ? null : value;
                _selectedZone = null;
              });
              if (value != null && value != 'All') {
                filterNotifier.updateCityCorporation(value);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'Zone',
            value: _selectedZone ?? 'Select Zone',
            items: _buildZoneItems(filterState),
            onChanged: (value) {
              setState(() {
                _selectedZone = value == 'Select Zone' ? null : value;
              });
              if (value != null && value != 'Select Zone') {
                filterNotifier.updateZone(value);
              }
            },
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _handleApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(Constants.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Filter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _handleReset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Reset'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _buildDivisionItems(FilterState filterState) {
    final divisionNames = filterState.divisions
        .map((d) => d.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    divisionNames.remove('All');
    return ['All', ...divisionNames];
  }

  List<String> _buildDistrictItems(FilterState filterState) {
    final districtNames = filterState.filteredDistricts
        .map((d) => d.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    districtNames.remove('All');
    return ['All', ...districtNames];
  }

  List<String> _buildCityCorporationItems(FilterState filterState) {
    final ccNames = filterState.cityCorporations
        .map((cc) => cc.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    ccNames.remove('All');
    return ['All', ...ccNames];
  }

  List<String> _buildUpazilaItems(FilterState filterState) {
    final upazilaNames = filterState.upazilas
        .map((u) => u.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    upazilaNames.remove('Select Upazila');
    return ['Select Upazila', ...upazilaNames];
  }

  List<String> _buildUnionItems(FilterState filterState) {
    final unionNames = filterState.unions
        .map((u) => u.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    unionNames.remove('Select Union');
    return ['Select Union', ...unionNames];
  }

  List<String> _buildWardItems(FilterState filterState) {
    final wardNames = filterState.wards
        .map((w) => w.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    wardNames.remove('Select Ward');
    return ['Select Ward', ...wardNames];
  }

  List<String> _buildZoneItems(FilterState filterState) {
    final zoneNames = filterState.zones
        .map((z) => z.name ?? '')
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList();
    zoneNames.remove('Select Zone');
    return ['Select Zone', ...zoneNames];
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final validValue =
        items.contains(value) ? value : (items.isNotEmpty ? items.first : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: validValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map((String item) {
              return Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              );
            }).toList();
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Full-screen dialog wrapper for geographic filters (EPI Center Finder, etc.).
class GeographicFilterDialog extends ConsumerWidget {
  const GeographicFilterDialog({
    super.key,
    required this.onApplied,
    required this.onReset,
  });

  final Future<void> Function() onApplied;
  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Color(Constants.cardColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GeographicFilterForm(
          onApply: (_) async {
            if (context.mounted) Navigator.of(context).pop();
            await onApplied();
          },
          onReset: () async {
            ref.read(filterControllerProvider.notifier).resetFilters();
            if (context.mounted) Navigator.of(context).pop();
            await onReset();
          },
        ),
      ),
    );
  }
}

/// Builds a short summary of the active geographic filter for display in headers.
String buildGeographicFilterSummary(FilterState filterState) {
  if (filterState.selectedAreaType == AreaType.cityCorporation) {
    if (filterState.selectedZone != null &&
        filterState.selectedZone != 'All' &&
        filterState.selectedZone != 'Select Zone') {
      return '${filterState.selectedCityCorporation ?? ''} / ${filterState.selectedZone}';
    }
    if (filterState.selectedCityCorporation != null &&
        filterState.selectedCityCorporation != 'All') {
      return filterState.selectedCityCorporation!;
    }
    return 'All City Corporations';
  }

  if (filterState.selectedWard != null &&
      filterState.selectedWard != 'All' &&
      filterState.selectedWard != 'Select Ward') {
    return filterState.selectedWard!;
  }
  if (filterState.selectedUnion != null &&
      filterState.selectedUnion != 'All' &&
      filterState.selectedUnion != 'Select Union') {
    return filterState.selectedUnion!;
  }
  if (filterState.selectedUpazila != null &&
      filterState.selectedUpazila != 'All' &&
      filterState.selectedUpazila != 'Select Upazila') {
    return filterState.selectedUpazila!;
  }
  if (filterState.selectedDistrict != null && filterState.selectedDistrict != 'All') {
    return filterState.selectedDistrict!;
  }
  if (filterState.selectedDivision != 'All') {
    return filterState.selectedDivision;
  }
  return 'All Areas';
}
