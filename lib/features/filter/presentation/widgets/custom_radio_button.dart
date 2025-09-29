import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final Color primaryColor;
  final String selectedVaccine;
  final ValueChanged<String> onChanged;

  const CustomRadioButton({
    required this.label,
    required this.primaryColor,
    required this.selectedVaccine,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(label);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            activeColor: primaryColor,
            value: label,
            groupValue: selectedVaccine,
            onChanged: (value) {
              onChanged(value!);
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