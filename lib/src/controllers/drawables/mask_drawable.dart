import 'dart:ui';
import 'package:flutter_painter_v2/flutter_painter.dart';

enum MaskType {
  imageWithTextMask,
  imageWithImageMask,
  textWithImageFill,
}

class MaskDrawable extends ObjectDrawable {
  final MaskType maskType;
  final Image baseImage;
  final Image? maskImage;
  final String? text;
  final TextStyle? textStyle;

  const MaskDrawable({
    required this.maskType,
    required this.baseImage,
    this.maskImage,
    this.text,
    this.textStyle,
    Offset position = Offset.zero,
    double rotation = 0.0,
    double scale = 1.0,
    bool hidden = false,
  }) : super(
    position: position,
    rotationAngle: rotation,
    scale: scale,
    hidden: hidden,
  );

  // Main method to draw the object on the canvas
  @override
  void drawObject(Canvas canvas, Size size) {
    // Define the source rect for the base image
    final sourceRect = Rect.fromLTWH(0, 0, baseImage.width.toDouble(), baseImage.height.toDouble());

    // Define the destination rect for the base image scaling
    final destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the base image onto the canvas using drawImageRect
    canvas.drawImageRect(baseImage, sourceRect, destinationRect, Paint());

    // Handle different MaskTypes
    switch (maskType) {
      case MaskType.imageWithTextMask:
        if (maskImage != null && text != null && textStyle != null) {
          // _drawImageWithTextMask(canvas, size, sourceRect, destinationRect);
        }
        break;
      case MaskType.imageWithImageMask:
        if (maskImage != null) {
          canvas.drawImageRect(baseImage, sourceRect, destinationRect, Paint());

          // Apply the image mask
          if (maskImage != null) {
            final maskPaint = Paint()..blendMode = BlendMode.dstIn;
            canvas.drawImageRect(maskImage!, sourceRect, destinationRect, maskPaint);

          }

          // _drawImageWithImageMask(canvas, size, sourceRect, destinationRect);
        }
        break;
      case MaskType.textWithImageFill:
        if (text != null && textStyle != null) {
        //  _drawTextWithImageFill(canvas, size, sourceRect, destinationRect);
        }
        break;
    }
  }

  // Function to handle image with text mask
  // void _drawImageWithTextMask(Canvas canvas, Size size, Rect sourceRect, Rect destinationRect) {
  //   // Draw the base image first
  //   canvas.drawImageRect(baseImage, sourceRect, destinationRect, Paint());
  //
  //   // Draw the text mask
  //   final textPainter = TextPainter(
  //     text: TextSpan(text: text, style: textStyle),
  //     textDirection: TextDirection.ltr,
  //   )..layout();
  //
  //   final offset = Offset(
  //     (size.width - textPainter.width) / 2,
  //     (size.height - textPainter.height) / 2,
  //   );
  //
  //   final maskPaint = Paint()..blendMode = BlendMode.dstIn;
  //   textPainter.paint(canvas, offset);
  // }

  // Function to handle image with image mask
  void _drawImageWithImageMask(Canvas canvas, Size size, Rect sourceRect, Rect destinationRect) {
    // Draw the base image first
    canvas.drawImageRect(baseImage, sourceRect, destinationRect, Paint());

    // Apply the image mask
    if (maskImage != null) {
      final maskPaint = Paint()..blendMode = BlendMode.dstIn;
      canvas.drawImageRect(maskImage!, sourceRect, destinationRect, maskPaint);
    }
  }

  // Function to handle text with image fill
  // void _drawTextWithImageFill(Canvas canvas, Size size, Rect sourceRect, Rect destinationRect) {
  //   // Draw the base image first
  //   canvas.drawImageRect(baseImage, sourceRect, destinationRect, Paint());
  //
  //   // Draw the text as a mask
  //   final textPainter = TextPainter(
  //     text: TextSpan(text: text, style: textStyle),
  //     textDirection: TextDirection.ltr,
  //   )..layout();
  //
  //   final offset = Offset(
  //     (size.width - textPainter.width) / 2,
  //     (size.height - textPainter.height) / 2,
  //   );
  //
  //   final maskPaint = Paint()..blendMode = BlendMode.dstIn;
  //   textPainter.paint(canvas, offset);
  // }

  @override
  ObjectDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    bool? locked,
  }) {
    return MaskDrawable(
      maskType: maskType,
      baseImage: baseImage,
      maskImage: maskImage,
      text: text,
      textStyle: textStyle,
      position: position ?? this.position,
      rotation: rotation ?? this.rotationAngle,
      scale: scale ?? this.scale,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return Size(
      baseImage.width.toDouble(),
      baseImage.height.toDouble(),
    );
  }
}
