import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  final Color backgroundColor;

  final double cornerRadius;

  final Color strokeColor;

  final double strokeWidth;

  final bool enableStroke;

  final bool enableShadow;

  final Color shadowColor;

  final double shadowBlurRadius;

  final Offset shadowOffset;

  /// The border radius of the rectangle.
  /// The default value is a circular radius of 5 on all corners.
  BorderRadius borderRadius;

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
    this.backgroundColor = Colors.black,
    this.cornerRadius = 0,
    this.strokeColor = Colors.transparent,
    this.shadowOffset = Offset.zero,
    this.enableStroke = false,
    this.enableShadow = false,
    this.shadowBlurRadius = 0,
    this.shadowColor = Colors.transparent,
    this.strokeWidth = 0.0,
    this.borderRadius = BorderRadius.zero,
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
    BorderRadius? borderRadius,
    Color? backgroundColor,
    double? cornerRadius,
    Color? strokeColor,
    double? strokeWidth,
    bool? enableStroke,
    bool? enableShadow,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
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
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      enableStroke: enableStroke ?? this.enableStroke,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
    );
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    final size = super.getSize();
    return Size(size.width, size.height);
  }
}
