import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VaccineCenterInfoOverlayWidget extends StatelessWidget {
  const VaccineCenterInfoOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.syringe,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Outreach Center',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.home, color: Colors.white, size: 10),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Fixed Center',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
          ],
        ),
      ],
    );
  }
}
