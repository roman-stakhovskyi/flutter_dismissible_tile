import 'package:flutter/material.dart';
import 'package:flutter_dismissible_tile/src/dismissible_painter.dart';
import 'package:flutter_dismissible_tile/src/dismissible_tile_direction.dart';

/// Used to animate the position of the overlay widget and to draw the animated
/// background of the overlay.
class DismissibleOverlay extends StatelessWidget {
  const DismissibleOverlay({
    super.key,
    required this.indent,
    required this.direction,
    required this.moveController,
    required this.dismissedColor,
    required this.overlay,
    required this.overlayDismissed,
    required this.dragUnderway,
    required this.onDismissiblePainter,
    required this.overlayTransitionBuilder,
    required this.overlayTransitionDuration,
  });

  final double indent;
  final DismissibleTileDirection direction;
  final AnimationController moveController;
  final Color? dismissedColor;
  final Widget? overlay;
  final Widget? overlayDismissed;
  final bool dragUnderway;
  final AnimatedSwitcherTransitionBuilder overlayTransitionBuilder;
  final Duration overlayTransitionDuration;
  final CustomPainter Function(
    double indent,
    Animation<double> animation,
    DismissibleTileDirection direction,
  )? onDismissiblePainter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final maxWidth = constraints.maxWidth;
        final x = maxWidth > 0 ? 1.0 + indent / maxWidth * 10 : 1.0;
        final alignAnimation = _getAlignmentAnimation(x);
        final content = AnimatedBuilder(
          animation: alignAnimation,
          builder: (_, child) => Align(
            alignment: alignAnimation.value,
            child: child,
          ),
          child: overlayDismissed == null
              ? overlay
              : AnimatedSwitcher(
                  duration: overlayTransitionDuration,
                  transitionBuilder: overlayTransitionBuilder,
                  child: dragUnderway
                      ? SizedBox(
                          key: ValueKey(dragUnderway),
                          child: overlay,
                        )
                      : overlayDismissed,
                ),
        );

        if (onDismissiblePainter != null) {
          return CustomPaint(
            painter: onDismissiblePainter!(
              indent,
              moveController.view,
              direction,
            ),
            child: content,
          );
        } else if (dismissedColor == null) {
          return content;
        }
        return CustomPaint(
          painter: DismissiblePainter(
            indent,
            dismissedColor!,
            moveController.view,
            direction,
          ),
          child: content,
        );
      },
    );
  }

  Animation<Alignment> _getAlignmentAnimation(double x) {
    final beginX = direction == DismissibleTileDirection.rightToLeft ? x : -x;
    return AlignmentTween(
      begin: Alignment(beginX, 0.0),
      end: Alignment.center,
    ).animate(moveController);
  }
}
