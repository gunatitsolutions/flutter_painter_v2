import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import 'shape_drawable.dart';
import '../sized2ddrawable.dart';

/// A drawable of a triangle.
class TriangleDrawable extends Sized2DDrawable implements ShapeDrawable {
  @override
  Paint paint;

  @override
  String? id;

  TriangleDrawable({
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
  })  : paint = paint ?? ShapeDrawable.defaultPaint,
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
  void drawObject(Canvas canvas, Size size) {
    final drawingSize = this.size * scale;
    final drawingPosition = position * scale;

    final halfWidth = drawingSize.width / 2;
    final halfHeight = drawingSize.height / 2;

    final path = Path()
      ..moveTo(drawingPosition.dx, drawingPosition.dy - halfHeight) // top
      ..lineTo(drawingPosition.dx - halfWidth, drawingPosition.dy + halfHeight) // bottom-left
      ..lineTo(drawingPosition.dx + halfWidth, drawingPosition.dy + halfHeight) // bottom-right
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  TriangleDrawable copyWith({
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
    return TriangleDrawable(
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
