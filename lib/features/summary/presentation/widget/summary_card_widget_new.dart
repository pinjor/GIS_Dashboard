import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

import '../../../../core/common/constants/constants.dart';

class SummaryCardWidgetNew extends StatelessWidget {
  // final String iconPath;
  final String label;
  final String value;
  // final String duration;
  final int boysCount;
  final int girlsCount;

  const SummaryCardWidgetNew({
    super.key,
    required this.label,
    required this.value,
    required this.boysCount,
    required this.girlsCount,
  });

  String _formatNumber(String value) {
    try {
      final num parsedValue = num.parse(value);
      final NumberFormat formatter = NumberFormat('#,###');
      return formatter.format(parsedValue);
    } catch (e) {
      return value; // Return original if not a valid number
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(Constants.primaryColor),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          4.h,
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          4.h,
          Row(
            children: [
              _childCountWidget(isBoy: true, count: boysCount),
              5.w,
              _childCountWidget(isBoy: false, count: girlsCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _childCountWidget({bool isBoy = true, required int count}) {
    return Row(
      children: [
        Icon(isBoy ? Icons.male : Icons.female, color: Colors.white),
        2.w,
        Text(
          isBoy ? 'Boys: ' : 'Girls: ',
          style: TextStyle(color: Colors.white),
        ),
        2.w,
        Text(
          _formatNumber(count.toString()),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
