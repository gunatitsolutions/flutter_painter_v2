
import 'package:flutter/material.dart';

import 'object_drawable.dart';

/// Text Drawable
class TextDrawable extends ObjectDrawable {
  /// The text to be drawn.
  final String text;

  /// The style the text will be drawn with.
  final TextStyle style;

  /// The direction of the text to be drawn.
  final TextDirection direction;

  // A text painter which will paint the text on the canvas.
  final TextPainter textPainter;

  final TextAlign textAlign;

  final bool showBackground;

  final Color backgroundColor;

  /// Creates a [TextDrawable] to draw [text].
  ///
  /// The path will be drawn with the passed [style] if provided.
  TextDrawable({
    required this.text,
    required Offset position,
    double rotation = 0,
    double scale = 1,
    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    this.backgroundColor = Colors.blueGrey,
    this.showBackground = false,
    this.textAlign = TextAlign.center,
    this.direction = TextDirection.ltr,
    bool locked = false,
    bool hidden = false,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
  })  : textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: textAlign,
          textScaler: TextScaler.linear(scale),
          textDirection: direction,
        ),
        super(
            position: position,
            rotationAngle: rotation,
            scale: scale,
            assists: assists,
            locked: locked,
            hidden: hidden);

  /// Draws the text on the provided [canvas] of size [size].
  @override
  void drawObject(Canvas canvas, Size size) {
    final maxTextWidth = size.width * scale;
    textPainter.layout(maxWidth: maxTextWidth);

    final drawingPosition = position * scale;
    final padding = 8.0;

    final lines = textPainter.computeLineMetrics();

    double lineYOffset = 0.0;

    for (final line in lines) {
      final lineHeight = line.height;
      final lineWidth = line.width;
      final baselineOffset = line.baseline - line.ascent;

      // Calculate full rect for the line
      final rect = Rect.fromLTWH(
        drawingPosition.dx + line.left - padding,
        drawingPosition.dy + lineYOffset + baselineOffset - padding,
        lineWidth + padding * 2,
        lineHeight + padding * 2,
      );

      if (showBackground) {
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(12));
        final paint = Paint()..color = backgroundColor;
        canvas.drawRRect(rrect, paint);
      }

      lineYOffset += lineHeight;
    }

    // Finally draw the actual text
    textPainter.paint(canvas, drawingPosition);
    /*// Render the text according to the size of the canvas taking the scale in mind
    textPainter.layout(maxWidth: size.width * scale);
    final drawingPosition = position * scale;
    // Paint the text on the canvas
    // It is shifted back by half of its width and height to be drawn in the center
    textPainter.paint(canvas,
        drawingPosition - Offset(textPainter.width / 2, textPainter.height / 2));*/
  }

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  TextDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    String? text,
    Offset? position,
    double? rotation,
    double? scale,
    TextStyle? style,
    bool? locked,
    TextDirection? direction,
    bool? showBackground,
    Color? backgroundColor,
  }) {
    return TextDrawable(
      text: text ?? this.text,
      position: position ?? this.position,
      rotation: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      style: style ?? this.style,
      direction: direction ?? this.direction,
      assists: assists ?? this.assists,
      hidden: hidden ?? this.hidden,
      locked: locked ?? this.locked,
      showBackground: showBackground ?? this.showBackground,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Calculates the size of the rendered object.
  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    // Generate the text as a visual layout
    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth * scale);
    return textPainter.size;
  }

  /// Compares two [TextDrawable]s for equality.
  // @override
  // bool operator ==(Object other) {
  //   return other is TextDrawable &&
  //       super == other &&
  //       other.text == text &&
  //       other.style == style &&
  //       other.direction == direction;
  // }
  //
  // @override
  // int get hashCode => hashValues(
  //     hidden,
  //     hashList(assists),
  //     hashList(assistPaints.entries),
  //     position,
  //     rotationAngle,
  //     scale,
  //     style,
  //     direction);
}
