import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'object_drawable.dart';

enum BackgroundType {
  noBackground,
  rect,
  stroke,
  slant;

  bool get isNoBackground => this == BackgroundType.noBackground;

  bool get isStroke => this == BackgroundType.stroke;

  bool get isRect => this == BackgroundType.rect;

  bool get isSlant => this == BackgroundType.slant;
}

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

  final Color backgroundColor;

  final double cornerRadius;

  final BackgroundType backgroundType;

  final Color strokeColor;

  final double strokeWidth;

  final bool enableStroke;

  final bool enableShadow;

  final Color shadowColor;

  final double shadowBlurRadius;

  final Offset shadowOffset;

  final bool showBackgroundBox;

  final double backgroundPadding;

  final int? maxLines;

  final bool softWrap;

  final TextOverflow overflow;

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
    this.backgroundColor = Colors.transparent,
    this.textAlign = TextAlign.center,
    this.direction = TextDirection.ltr,
    this.cornerRadius = 12,
    this.backgroundType = BackgroundType.noBackground,
    this.strokeColor = Colors.transparent,
    this.strokeWidth = 0,
    this.enableStroke = false,
    this.enableShadow = false,
    this.shadowColor = Colors.black38,
    this.shadowBlurRadius = 4.0,
    this.shadowOffset = const Offset(2, 2),
    this.showBackgroundBox = false,
    this.backgroundPadding = 8,
    this.maxLines,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    bool locked = false,
    bool hidden = false,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
  })  : textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: textAlign,
          textScaler: TextScaler.linear(scale),
          textDirection: direction,
          maxLines: maxLines,
          ellipsis: overflow == TextOverflow.ellipsis ? '…' : null,
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
    // Layout text with scaled max width
   /* textPainter.layout(maxWidth: size.width * scale);

    // Paint the text on the canvas
    // It is shifted back by half of its width and height to be drawn in the center
    textPainter.paint(canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2));*/
    double maxTextWidth = softWrap ? size.width * scale : double.infinity;

    textPainter.layout(maxWidth: maxTextWidth);
  //  textPainter.layout(maxWidth: size.width * scale);
    final Offset drawOffset =
        position - Offset(textPainter.width / 2, textPainter.height / 2);

    final Rect textRect = drawOffset & textPainter.size;
    final Rect paddedRect = textRect.inflate(backgroundPadding);

    if (backgroundType.isRect || backgroundType.isStroke || backgroundType.isSlant) {
      final RRect background = RRect.fromRectAndRadius(
        paddedRect,
        Radius.circular(cornerRadius),
      );

      final Paint bgPaint = Paint()..color = backgroundColor;

      if (enableShadow) {
        canvas.drawShadow(Path()..addRRect(background), shadowColor, shadowBlurRadius, true);
      }

      if (backgroundType.isSlant) {
        final Path slantPath = Path()
          ..moveTo(paddedRect.left, paddedRect.top + 20)
          ..lineTo(paddedRect.left + 20, paddedRect.top)
          ..lineTo(paddedRect.right, paddedRect.top)
          ..lineTo(paddedRect.right, paddedRect.bottom - 20)
          ..lineTo(paddedRect.right - 20, paddedRect.bottom)
          ..lineTo(paddedRect.left, paddedRect.bottom)
          ..close();
        canvas.drawPath(slantPath, bgPaint);
      } else {
        canvas.drawRRect(background, bgPaint);
      }

      if (enableStroke || backgroundType.isStroke) {
        final Paint strokePaint = Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
        if (backgroundType.isSlant) {
          final Path slantPath = Path()
            ..moveTo(paddedRect.left, paddedRect.top + 20)
            ..lineTo(paddedRect.left + 20, paddedRect.top)
            ..lineTo(paddedRect.right, paddedRect.top)
            ..lineTo(paddedRect.right, paddedRect.bottom - 20)
            ..lineTo(paddedRect.right - 20, paddedRect.bottom)
            ..lineTo(paddedRect.left, paddedRect.bottom)
            ..close();
          canvas.drawPath(slantPath, strokePaint);
        } else {
          canvas.drawRRect(background, strokePaint);
        }
      }
    }

    textPainter.paint(canvas, drawOffset);
   /* final maxTextWidth = size.width;
    textPainter.layout(maxWidth: maxTextWidth);

    // Compute full text block size
    final lines = textPainter.computeLineMetrics();
    final totalHeight = lines.fold(0.0, (sum, line) => sum + line.height);
    final totalWidth = textPainter.width;

    // Apply scaling to size and padding
    final scaledPadding = backgroundPadding * scale;
    final scaledCornerRadius = cornerRadius * scale;

    final centeredPosition = position -
        Offset((totalWidth + scaledPadding * 2) / 2, (totalHeight + scaledPadding) / 2);

    // Save the canvas state
    canvas.save();

    // Apply scale and move canvas to final drawing origin
    canvas.translate(centeredPosition.dx * scale, centeredPosition.dy * scale);
    canvas.scale(scale);

    double yOffset = 0.0;
    for (final line in lines) {
      final lineHeight = line.height;
      final lineWidth = line.width;

      final rect = Rect.fromLTWH(
        0,
        yOffset,
        lineWidth + scaledPadding * 2 / scale, // Remove extra scaling here
        lineHeight + scaledPadding / scale,
      );

      if (!backgroundType.isNoBackground) {
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(scaledCornerRadius / scale));
        final paint = Paint()
          ..color = backgroundType.isStroke ? strokeColor : backgroundColor
          ..style = backgroundType.isStroke ? PaintingStyle.stroke : PaintingStyle.fill;

        if (backgroundType.isSlant) {
          const slant = 10.0;
          final path = Path()
            ..moveTo(rrect.left + slant, rrect.top)
            ..lineTo(rrect.right, rrect.top)
            ..lineTo(rrect.right - slant, rrect.bottom)
            ..lineTo(rrect.left, rrect.bottom)
            ..close();
          canvas.drawPath(path, paint);
        } else {
          canvas.drawRRect(rrect, paint);
        }
      }

      yOffset += lineHeight;
    }

    // Draw the text itself (shifted by padding)
    textPainter.paint(canvas, Offset(scaledPadding / scale, 0));

    // Restore the canvas
    canvas.restore();*/
  /*  // final maxTextWidth = size.width * scale;
    // textPainter.layout(maxWidth: maxTextWidth);
    //
    // final drawingPosition = position * scale;
    //
    // // final drawingPosition = position * scale - Offset(textPainter.width / 2, textPainter.height / 2);

    final maxTextWidth = size.width * scale;
    textPainter.layout(maxWidth: maxTextWidth);

// Center the text properly
    final drawingPosition = position * scale -
        Offset(textPainter.width / 2, textPainter.height / 2);

// Adjust the selection area to match the text's bounding box
    // final selectionOffset = Offset(textPainter.width / 2, textPainter.height / 2);

    final lines = textPainter.computeLineMetrics();

    double lineYOffset = 0.0;

    for (final line in lines) {
      final lineHeight = line.height;
      final lineWidth = line.width;
      //  final baselineOffset = line.baseline - line.ascent;

      // Calculate full rect for the line
      final rect = Rect.fromLTWH(
        drawingPosition.dx - backgroundPadding,
        drawingPosition.dy + lineYOffset - backgroundPadding / 2,
        lineWidth + backgroundPadding * 2,
        lineHeight + backgroundPadding,
      );
      /*  final rect = Rect.fromLTWH(
        drawingPosition.dx + line.left - padding,
        drawingPosition.dy + line.baseline - lineHeight,
        // drawingPosition.dy + lineYOffset + baselineOffset - padding,
        // drawingPosition.dy + lineYOffset + lineHeight - padding - baselineOffset,
        lineWidth + padding * 2,
        lineHeight + padding,
      );*/

      if (!backgroundType.isNoBackground) {
        final rrect =
            RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius));
        final paint = Paint()
          ..color = backgroundType.isStroke ? strokeColor : backgroundColor
          ..style = backgroundType.isStroke
              ? PaintingStyle.stroke
              : PaintingStyle.fill
          ..maskFilter = ui.MaskFilter.blur(
            ui.BlurStyle.normal,
            shadowBlurRadius,
          );

        // ..style = PaintingStyle.stroke   // <-- Only stroke, no fill
        // ..strokeWidth = 2.0;

        //slant type
        if (backgroundType.isSlant) {
          const slant = 10.0;
          final path = Path()
            ..moveTo(rrect.left + slant, rrect.top) // Top-left
            ..lineTo(rrect.right, rrect.top) // Top-right
            ..lineTo(rrect.right - slant, rrect.bottom) // Bottom-right
            ..lineTo(rrect.left, rrect.bottom) // Bottom-left
            ..close();
          canvas.drawPath(path, paint);
        } else if (backgroundType.isRect) {
          canvas.drawRRect(rrect, paint);
        }
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
        drawingPosition - Offset(textPainter.width / 2, textPainter.height / 2));*/*/
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
    TextAlign? textAlign,
    TextStyle? style,
    bool? locked,
    TextDirection? direction,
    BackgroundType? backgroundType,
    Color? backgroundColor,
    Color? strokeColor,
    double? strokeWidth,
    bool? enableStroke,
    bool? enableShadow,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    bool? showBackgroundBox,
    double? backgroundPadding,
    int? maxLines,
    bool? softWrap,
    TextOverflow? overflow,
  }) {
    return TextDrawable(
      text: text ?? this.text,
      position: position ?? this.position,
      rotation: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      direction: direction ?? this.direction,
      assists: assists ?? this.assists,
      hidden: hidden ?? this.hidden,
      locked: locked ?? this.locked,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      enableStroke: enableStroke ?? this.enableStroke,
      enableShadow: enableShadow ?? this.enableShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      showBackgroundBox: showBackgroundBox ?? this.showBackgroundBox,
      backgroundPadding: backgroundPadding ?? this.backgroundPadding,
      maxLines: maxLines ?? this.maxLines,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
    );
  }

  Size size() {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.size;
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
