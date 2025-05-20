import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

enum MaskType {
  imageWithTextMask,
  imageWithImageMask,
  textWithImageFill,
}

class MaskDrawable extends ObjectDrawable {
  final MaskType maskType;
  final ui.Image baseImage;
  final ui.Image? maskImage;
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
    Set<ObjectDrawableAssist> assists = const {},
    bool locked = false,
  }) : super(
    position: position,
    rotationAngle: rotation,
    scale: scale,
    hidden: hidden,
    assists: assists,
    locked: locked,
  );

  @override
  void drawObject(Canvas canvas, Size size) {
    final painter = MaskPainter(
      type: maskType,
      baseImage: baseImage,
      maskImage: maskImage,
      maskText: text,
      textStyle: textStyle,
    );
    painter.paint(canvas, size);
  }

  @override
  Size getSize({double minWidth = 0, double maxWidth = double.infinity}) {
    return Size(
      baseImage.width.toDouble(),
      baseImage.height.toDouble(),
    );
  }

  @override
  ObjectDrawable copyWith({
    Offset? position,
    double? rotation,
    double? scale,
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
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
      assists: assists ?? this.assists,
      locked: locked ?? this.locked,
    );
  }
}


class MaskPainter extends CustomPainter {
  final MaskType type;
  final ui.Image? baseImage;
  final ui.Image? maskImage;
  final String? maskText;
  final TextStyle? textStyle;

  MaskPainter({
    required this.type,
    this.baseImage,
    this.maskImage,
    this.maskText,
    this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) async {
    switch (type) {
      case MaskType.imageWithTextMask:
        if (baseImage != null && maskText != null && textStyle != null) {
          await _paintImageWithTextMask(canvas, size);
        }
        break;
      case MaskType.imageWithImageMask:
        if (baseImage != null && maskImage != null) {
          await _paintImageWithImageMask(canvas, size);
        }
        break;
      case MaskType.textWithImageFill:
        if (baseImage != null && maskText != null && textStyle != null) {
          await _paintTextWithImageFill(canvas, size);
        }
        break;
    }
  }

  Future<void> _paintImageWithTextMask(Canvas canvas, Size size) async {
    final recorder = ui.PictureRecorder();
    final offCanvas = Canvas(recorder);

    // Draw base image
    offCanvas.drawImage(baseImage!, Offset.zero, Paint());

    // Draw text mask
    final textPainter = TextPainter(
      text: TextSpan(text: maskText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    final maskPaint = Paint()..blendMode = BlendMode.dstIn;
    textPainter.paint(offCanvas, offset);

    final picture = recorder.endRecording();
    final maskedImage = await picture.toImage(size.width.toInt(), size.height.toInt());
    canvas.drawImage(maskedImage, Offset.zero, Paint());
  }

  Future<void> _paintImageWithImageMask(Canvas canvas, Size size) async {
    final recorder = ui.PictureRecorder();
    final offCanvas = Canvas(recorder);

    offCanvas.drawImage(baseImage!, Offset.zero, Paint());
    final maskPaint = Paint()..blendMode = BlendMode.dstIn;
    offCanvas.drawImage(maskImage!, Offset.zero, maskPaint);

    final picture = recorder.endRecording();
    final maskedImage = await picture.toImage(size.width.toInt(), size.height.toInt());
    canvas.drawImage(maskedImage, Offset.zero, Paint());
  }

  Future<void> _paintTextWithImageFill(Canvas canvas, Size size) async {
    final recorder = ui.PictureRecorder();
    final offCanvas = Canvas(recorder);

    offCanvas.drawImage(baseImage!, Offset.zero, Paint());

    final textPainter = TextPainter(
      text: TextSpan(text: maskText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    final maskPaint = Paint()..blendMode = BlendMode.dstIn;
    textPainter.paint(offCanvas, offset);

    final picture = recorder.endRecording();
    final maskedImage = await picture.toImage(size.width.toInt(), size.height.toInt());
    canvas.drawImage(maskedImage, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
