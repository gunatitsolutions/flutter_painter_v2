import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/src/controllers/drawables/sized2ddrawable.dart';
import '../../../../flutter_painter.dart';
import '../sized1ddrawable.dart';

class CustomPathDrawable extends Sized2DDrawable implements ShapeDrawable {
  final Path originalPath;
  @override
  Paint paint;

  @override
  String? id;

  CustomPathDrawable({
    required this.originalPath,
    required Offset position,
    required Size size,
    Paint? paint,
    double rotationAngle = 0,
    double scale = 1,
    Set<ObjectDrawableAssist> assists = const {},
    Map<ObjectDrawableAssist, Paint> assistPaints = const {},
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
        id: id ?? this.id);
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

    // Apply transform: translate -> rotate -> scale
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotationAngle);
    canvas.scale(scale);

    // Draw original path from origin
    canvas.drawPath(originalPath, paint);

    canvas.restore();
  }
}
