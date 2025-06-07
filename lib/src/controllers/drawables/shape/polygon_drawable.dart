import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

import '../object_drawable.dart';
import 'shape_drawable.dart';
import '../sized2ddrawable.dart';

class PolygonDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  final int sides;

  @override
  String? id;

  PolygonDrawable({
    required this.sides,
    Paint? paint,
    required Size size,
    required Offset position,
    double rotationAngle = 0,
    double scale = 1,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
    Map<ObjectDrawableAssist, Paint> assistPaints =
    const <ObjectDrawableAssist, Paint>{},
    bool locked = false,
    bool hidden = false,
    this.id,
  })  : assert(sides >= 3, 'Polygon must have at least 3 sides'),
        paint = paint ?? ShapeDrawable.defaultPaint,
        super(
        size: size,
        position: position,
        rotationAngle: rotationAngle,
        scale: scale,
        assists: assists,
        assistPaints: assistPaints,
        locked: locked,
        hidden: hidden,
      );

  @protected
  @override
  EdgeInsets get padding => EdgeInsets.all(paint.strokeWidth / 2);

  @override
  void drawObject(Canvas canvas, Size canvasSize) {
    final drawingSize = size * scale;
    final drawingPosition = position * scale;
    final radius = math.min(drawingSize.width, drawingSize.height) / 2;

    final angleStep = (2 * math.pi) / sides;

    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = angleStep * i - math.pi / 2 + rotationAngle;
      final x = drawingPosition.dx + radius * math.cos(angle);
      final y = drawingPosition.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  PolygonDrawable copyWith({
    int? sides,
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Size? size,
    Paint? paint,
    bool? locked,
    String? id,
  }) {
    return PolygonDrawable(
      sides: sides ?? this.sides,
      hidden: hidden ?? this.hidden,
      assists: assists ?? this.assists,
      position: position ?? this.position,
      rotationAngle: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      paint: paint ?? this.paint,
      locked: locked ?? this.locked,
      id: id ?? this.id,
    );
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    final size = super.getSize();
    return Size(size.width, size.height);
  }
}
