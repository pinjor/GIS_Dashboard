import 'package:flutter/material.dart';

class StaticCompassDirectionIndicatorWidget extends StatelessWidget {
  const StaticCompassDirectionIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Stack(
          children: [
            // North
            Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // South
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // East
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  'E',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            // West
            Positioned(
              left: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
