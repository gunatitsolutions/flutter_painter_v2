import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/src/controllers/drawables/sized2ddrawable.dart';
import '../../../../flutter_painter.dart';

class CustomPathDrawable extends Sized2DDrawable implements ShapeDrawable {
  final Path originalPath;
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

  final double opacity;

  CustomPathDrawable({
    required this.originalPath,
    required Offset position,
    required Size size,
    Paint? paint,
    this.backgroundColor = Colors.black,
    this.cornerRadius = 0,
    this.strokeColor = Colors.transparent,
    this.shadowOffset = Offset.zero,
    this.enableStroke = false,
    this.enableShadow = false,
    this.shadowBlurRadius = 0,
    this.shadowColor = Colors.transparent,
    this.strokeWidth = 0.0,
    double rotationAngle = 0,
    double scale = 1,
    Set<ObjectDrawableAssist> assists = const {},
    Map<ObjectDrawableAssist, Paint> assistPaints = const {},
    bool locked = false,
    bool hidden = false,
    this.id,
    this.opacity = 1.0,
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

  @override
  CustomPathDrawable copyWith({
    Offset? position,
    double? rotation,
    double? scale,
    Paint? paint,
    Set<ObjectDrawableAssist>? assists,
    Map<ObjectDrawableAssist, Paint>? assistPaints,
    bool? locked,
    bool? hidden,
    Size? size,
    String? id,
    Color? backgroundColor,
    double? cornerRadius,
    Color? strokeColor,
    double? strokeWidth,
    bool? enableStroke,
    bool? enableShadow,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    double? opacity,
  }) {
    return CustomPathDrawable(
      originalPath: originalPath,
      position: position ?? this.position,
      rotationAngle: rotation ?? this.rotationAngle,
      scale: scale ?? this.scale,
      paint: paint ?? this.paint,
      assists: assists ?? this.assists,
      assistPaints: assistPaints ?? this.assistPaints,
      locked: locked ?? this.locked,
      hidden: hidden ?? this.hidden,
      size: size ?? this.size,
      id: id ?? this.id,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      enableStroke: enableStroke ?? this.enableStroke,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      opacity:  opacity ?? this.opacity,
    );
  }

  @override
  Rect getRect() {
    final transformed = originalPath.getBounds();
    final scaled = Rect.fromLTWH(
      position.dx,
      position.dy,
      transformed.width * scale,
      transformed.height * scale,
    );
    return scaled;
  }

  @override
  void drawObject(Canvas canvas, Size size) {
    if (hidden) return;

    canvas.save();

    // Apply overall transformations
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotationAngle);
    canvas.scale(scale);

    // Step 1: Get original path bounds
    final bounds = originalPath.getBounds();

    // Step 2: Shift the path to center it at (0, 0)
    final centeredPath = originalPath.shift(-bounds.center);

    // Optional: Draw shadow
    if (enableShadow) {
      final shadowPaint = Paint()
        ..color = shadowColor.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);

      canvas.drawPath(centeredPath.shift(shadowOffset), shadowPaint);
    }

    // Fill (background color)
    final fillPaint = Paint()
      ..color = backgroundColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawPath(centeredPath, fillPaint);

    // Stroke
    if (enableStroke && strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = strokeColor.withValues(alpha: opacity)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(centeredPath, strokePaint);
    }

    canvas.restore();
   /* if (hidden) return;

    canvas.save();

    // Apply transform: translate -> rotate -> scale
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotationAngle);
    canvas.scale(scale);

    // Draw shadow if enabled
    if (enableShadow) {
      final shadowPaint = Paint()
        ..color = shadowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius);

      final shadowPath = originalPath.shift(shadowOffset);
      canvas.drawPath(shadowPath, shadowPaint);
    }

    // Draw fill (background color)
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(originalPath, fillPaint);

    // Draw stroke if enabled
    if (enableStroke && strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(originalPath, strokePaint);
    }

    canvas.restore();*/
    // if (hidden) return;
    //
    // canvas.save();
    //
    // // Apply transform: translate -> rotate -> scale
    // canvas.translate(position.dx, position.dy);
    // canvas.rotate(rotationAngle);
    // canvas.scale(scale);
    //
    // // Draw original path from origin
    // canvas.drawPath(originalPath, paint);
    //
    // canvas.restore();
  }
}
