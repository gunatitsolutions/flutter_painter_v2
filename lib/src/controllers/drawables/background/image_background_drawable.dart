import 'dart:ui';

import 'package:flutter/material.dart' as mt;
import 'background_drawable.dart';

/// Drawable to use an image as a background.
@mt.immutable
class ImageBackgroundDrawable extends BackgroundDrawable {
  /// The image to be used as a background.
  final Image image;

  /// Optional shader to apply (e.g., gradient).
  final Shader? shader;

  /// Optional image filter (e.g., blur).
  final ImageFilter? imageFilter;

  /// Optional color filter (e.g., grayscale, tint).
  final ColorFilter? colorFilter;

  /// Filter quality for scaling the image.
  final FilterQuality filterQuality;

  final Size? fittedSize;

  final mt.BoxFit fit;

  /// Creates a [ImageBackgroundDrawable] to use an image as a background.
  const ImageBackgroundDrawable({
    required this.image,
    this.fittedSize,
    this.shader,
    this.imageFilter,
    this.colorFilter,
    this.filterQuality = FilterQuality.low,
    this.fit = mt.BoxFit.cover,
  });

  /// Draws the image on the provided [canvas] of size [size].
  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = filterQuality;

    if (shader != null) {
      paint.shader = shader;
    }

    if (colorFilter != null) {
      paint.colorFilter = colorFilter;
    }

    final inputSize = Size(image.width.toDouble(), image.height.toDouble());
    final outputSize = size;

    final fittedSizes = mt.applyBoxFit(fit, inputSize, outputSize);
    final sourceSize = fittedSizes.source;
    final destinationSize = fittedSizes.destination;

    final dx = (size.width - destinationSize.width) / 2;
    final dy = (size.height - destinationSize.height) / 2;

    final srcRect = mt.Alignment.center.inscribe(sourceSize, Offset.zero & inputSize);
    final dstRect = Rect.fromLTWH(dx, dy, destinationSize.width, destinationSize.height);

    if (imageFilter != null) {
      // Save only the image area with blur filter
      canvas.saveLayer(dstRect, Paint()..imageFilter = imageFilter!);
    }

    // Draw the image
    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      (shader == null && colorFilter == null) ? Paint() : paint,
    );

    if (imageFilter != null) {
      canvas.restore(); // Restore after background only
    }
    /* final paint = Paint()..filterQuality = filterQuality;

    // Apply shader if available.
    if (shader != null) {
      paint.shader = shader;
    }

    // Apply color filter if available.
    if (colorFilter != null) {
      paint.colorFilter = colorFilter;
    }

    if (imageFilter != null) {
      // Save the layer with an image filter.
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..imageFilter = imageFilter!,
      );
    }

    // Draw the image onto the canvas with applied paint.
    // canvas.drawImageRect(
    //   image,
    //   Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    //   Rect.fromLTWH(0, 0, size.width, size.height),
    //   paint,
    // );

    // if (imageFilter != null) {
    //   canvas.restore(); // Restore the layer when imageFilter is applied.
    // }
    // Draw the image onto the canvas.

    final inputSize = Size(image.width.toDouble(), image.height.toDouble());
    final outputSize = size;

    final fittedSizes = mt.applyBoxFit(fit, inputSize, outputSize);
    final sourceSize = fittedSizes.source;
    final destinationSize = fittedSizes.destination;

    final dx = (size.width - destinationSize.width) / 2;
    final dy = (size.height - destinationSize.height) / 2;

    final srcRect =
        mt.Alignment.center.inscribe(sourceSize, Offset.zero & inputSize);
    final dstRect =
        Rect.fromLTWH(dx, dy, destinationSize.width, destinationSize.height);

    canvas.drawImageRect(
        image,
        srcRect,
        dstRect,
        (imageFilter == null && colorFilter == null && shader == null)
            ? Paint()
            : paint);
    // canvas.drawImageRect(
    //     image,
    //     Rect.fromPoints(Offset.zero,
    //         Offset(image.width.toDouble(), image.height.toDouble())),
    //     Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
    //     (imageFilter == null && colorFilter == null && shader == null)
    //         ? Paint()
    //         : paint);*/
  }

  ImageBackgroundDrawable copyWith({
    Image? image,
    Size? fittedSize,
    Shader? shader,
    ImageFilter? imageFilter,
    ColorFilter? colorFilter,
    FilterQuality? filterQuality,
    mt.BoxFit? fit,
  }) {
    return ImageBackgroundDrawable(
      image: image ?? this.image,
      fittedSize: fittedSize ?? this.fittedSize,
      shader: shader ?? this.shader,
      imageFilter: imageFilter ?? this.imageFilter,
      colorFilter: colorFilter ?? this.colorFilter,
      filterQuality: filterQuality ?? this.filterQuality,
      fit: fit ?? this.fit,
    );
  }

// /// Compares two [ImageBackgroundDrawable]s for equality.
// @override
// bool operator ==(Object other) {
//   return other is ImageBackgroundDrawable && other.image == image;
// }
//
// @override
// int get hashCode => image.hashCode;
}

/// An extension on ui.Image to create a background drawable easily.
extension ImageBackgroundDrawableGetter on Image {
  /// Returns an [ImageBackgroundDrawable] of the current [Image].
  ImageBackgroundDrawable get backgroundDrawable => ImageBackgroundDrawable(
    image: this,
  );
}
