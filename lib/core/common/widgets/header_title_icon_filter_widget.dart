// 📁 widgets/header_title_with_filter.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';

import '../../../features/map/presentation/widget/filter_widget.dart';

class HeaderTitleIconFilterWidget extends StatelessWidget {
  final String region;
  final String year;
  final String vaccine;
  final VoidCallback? onFilterTap;

  const HeaderTitleIconFilterWidget({
    super.key,
    required this.region,
    required this.year,
    required this.vaccine,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$region, $year",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            Text(
              vaccine,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        IconButton(
          icon: SvgPicture.asset(
            Constants.filterIconPath,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          onPressed:
              onFilterTap ??
              () {
                showDialog(
                  context: context,
                  builder: (_) => const Dialog(
                    backgroundColor: Color(Constants.cardColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    insetPadding: EdgeInsets.symmetric(horizontal: 16),
                    child: FilterWidget(),
                  ),
                );
              },
        ),
      ],
    );
  }
}
