import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/providers/filter_provider.dart';

import '../../../features/map/presentation/widget/filter_dialog_box_widget.dart';

class HeaderTitleIconFilterWidget extends ConsumerWidget {
  final VoidCallback? onFilterTap;

  const HeaderTitleIconFilterWidget({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bangladesh, ${filterState.selectedYear}",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            Text(
              filterState.selectedVaccine,
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
                    child: FilterDialogBoxWidget(),
                  ),
                );
              },
        ),
      ],
    );
  }
}
