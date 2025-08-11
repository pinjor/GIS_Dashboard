import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomLoadingMapWidget extends ConsumerStatefulWidget {
  const CustomLoadingMapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomLoadingMapWidgetState();
}

class _CustomLoadingMapWidgetState extends ConsumerState<CustomLoadingMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const loadingText = 'Loading map...';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated line indicator
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 120, // Same width as text approximately
              height: 15,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Positioned(
                    left:
                        _animation.value *
                        (120 - 40), // Move from 0 to (total_width - bar_width)
                    child: Container(
                      width: 40,
                      height: 15,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orangeAccent.shade100,
                            Colors.orange.shade700,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Loading text
        const Text(
          loadingText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
