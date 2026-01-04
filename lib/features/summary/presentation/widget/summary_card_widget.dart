import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gis_dashboard/core/utils/utils.dart';

import '../../../../core/common/constants/constants.dart';

class SummaryCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final int boysCount;
  final int girlsCount;
  final bool isFirst;

  const SummaryCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.boysCount,
    required this.girlsCount,
    this.isFirst = true,
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
        borderRadius: BorderRadius.circular(8),
        color: Color(Constants.primaryColor),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // 🔍 DEBUG LOG
          Builder(
            builder: (context) {
              if (label.contains('Total Children')) {
                logg.i('''
🔍 SUMMARY CARD DEBUG:
Label: $label
Value: $value
Boys: $boysCount
Girls: $girlsCount
-------------------
''');
              }
              return const SizedBox.shrink();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.h,
              Text(
                _formatNumber(value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
          Positioned(
            top: 4,
            right: 4,
            child: Image.asset(
              isFirst ? Constants.childrenIconPath : Constants.dosesIconPath,
              width: isFirst ? 45 : 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _childCountWidget({bool isBoy = true, required int count}) {
    return Row(
      children: [
        Image.asset(
          isBoy ? Constants.boyIconPath : Constants.girlIconPath,
          color: Colors.white,
          width: isBoy ? 12 : 18,
        ),
        4.w,
        Text(
          isBoy ? 'Boys: ' : 'Girls: ',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          _formatNumber(count.toString()),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
