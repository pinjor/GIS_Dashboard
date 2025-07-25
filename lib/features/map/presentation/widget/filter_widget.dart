// 📁 widgets/filter_panel.dart
import 'package:flutter/material.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String _selectedAreaType = 'district'; /// Tracks selected radio button
  String _selectedVaccine = 'Penta-1'; /// Tracks selected vaccine

  final _formKey = GlobalKey<FormState>();

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
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: '2025',
                items: ['2025', '2024', '2023']
                    .map(
                      (year) =>
                          DropdownMenuItem(value: year, child: Text(year)),
                    )
                    .toList(),
                onChanged: (value) {},
              ),
              16.h,
              const Text(
                'Division',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              8.h,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search Division',
                  border: OutlineInputBorder(),
                ),
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
                        _buildRadio('Penta-1', primaryColor),
                        _buildRadio('Penta-2', primaryColor),
                        _buildRadio('Penta-3', primaryColor),
                      ],
                    ),
                  ),
                  // Second column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        _buildRadio('MR-1', primaryColor),
                        _buildRadio('MR-2', primaryColor),
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

                      onPressed: () {},
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
                      onPressed: () {},
                      child: const Text(
                        'Clear',
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
