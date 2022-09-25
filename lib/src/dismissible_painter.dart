import 'package:flutter/material.dart';
import 'package:flutter_dismissible_tile/src/dismissible_tile_direction.dart';

/// Painter for dismissible overlay.
///
/// Paints the layer with the CustomPainter over the background.
class DismissiblePainter extends CustomPainter {
  const DismissiblePainter(
    this.indent,
    this.color,
    this.animation,
    this.direction,
  );

  final Color color;
  final double indent;
  final Animation<double> animation;
  final DismissibleTileDirection direction;

  static const _minHeight = 100;
  static const _pi = 3.1415926535897932;

  @override
  void paint(Canvas canvas, Size size) {
    final isRtlDirection = direction == DismissibleTileDirection.rightToLeft;
    final paint = Paint()..color = color;
    final diameter = 2 * animation.value * (size.width + indent);
    final dx = isRtlDirection ? size.width + indent : -indent;
    final dy = size.height / 2;

    final double rectHeight;
    if (animation.value > 0.995) {
      rectHeight = 3 * diameter;
    } else if (size.height <= _minHeight) {
      rectHeight = diameter / 1.3;
    } else {
      rectHeight = diameter;
    }

    final rect = Rect.fromCenter(
      width: diameter,
      height: rectHeight,
      center: Offset(dx, dy),
    );
    if (animation.isCompleted) {
      canvas.drawRect(rect, paint);
    } else if (size.height > _minHeight) {
      final startAngle = isRtlDirection ? 3 * _pi : 1.5 * _pi;
      final sweepAngle = isRtlDirection ? 2 * _pi : _pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    } else {
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(DismissiblePainter oldDelegate) =>
      oldDelegate.animation.value != animation.value ||
      oldDelegate.color != color ||
      oldDelegate.indent != indent ||
      oldDelegate.direction != direction;
}
