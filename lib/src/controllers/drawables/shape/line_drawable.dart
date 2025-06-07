
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../object_drawable.dart';
import 'shape_drawable.dart';
import '../sized1ddrawable.dart';

/// A drawable of a simple line shape.
class LineDrawable extends Sized1DDrawable implements ShapeDrawable {
  /// The paint to be used for the line drawable.
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

  /// Creates a new [LineDrawable] with the given [length] and [paint].
  LineDrawable({
    Paint? paint,
    required double length,
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
    this.borderRadius =  BorderRadius.zero,
    this.id,
  })  : paint = paint ?? ShapeDrawable.defaultPaint,
        super(
            length: length,
            position: position,
            rotationAngle: rotationAngle,
            scale: scale,
            assists: assists,
            assistPaints: assistPaints,
            locked: locked,
            hidden: hidden);

  /// Getter for padding of drawable.
  ///
  /// Add padding equal to the stroke width of the line.
  @protected
  @override
  EdgeInsets get padding => EdgeInsets.all(paint.strokeWidth / 2);

  /// Draws the line on the provided [canvas] of size [size].
  @override
  void drawObject(Canvas canvas, Size size) {


    if (backgroundColor.alpha != 0) {
      final paint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawLine(position.translate(-length / 2 * scale, 0),
          position.translate(length / 2 * scale, 0), paint);

    }

    // 2. Stroke
    if (strokeWidth > 0 && strokeColor.alpha != 0) {
      final paint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawLine(position.translate(-length / 2 * scale, 0),
          position.translate(length / 2 * scale, 0), paint);

    }
  }

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  LineDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    double? length,
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
    return LineDrawable(
      hidden: hidden ?? this.hidden,
      assists: assists ?? this.assists,
      position: position ?? this.position,
      rotationAngle: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      length: length ?? this.length,
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

  /// Compares two [LineDrawable]s for equality.
  // @override
  // bool operator ==(Object other) {
  //   return other is LineDrawable &&
  //       super == other &&
  //       other.paint == paint &&
  //       other.length == length;
  // }
  //
  // @override
  // int get hashCode => hashValues(
  //     hidden,
  //     locked,
  //     hashList(assists),
  //     hashList(assistPaints.entries),
  //     position,
  //     rotationAngle,
  //     scale,
  //     paint,
  //     length);
}
