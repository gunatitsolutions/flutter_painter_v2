import 'package:flutter/cupertino.dart';

import 'background_drawable.dart';

/// Drawable to use a color as a background.
class ColorBackgroundDrawable extends BackgroundDrawable {
  /// The color to be used as a background.
  final Color color;

  /// Optional shader to apply (e.g., gradient).
  final Shader? shader;

  Rect? _cachedRect;

  /// Creates a [ColorBackgroundDrawable] to use a color as a background.
   ColorBackgroundDrawable({
    required this.color,
    this.shader,
  });

  /// Draws the background on the provided [canvas] of size [size].
  @override
  void draw(Canvas canvas, Size size) {
    // Draw the color onto the canvas
    canvas.drawColor(color, BlendMode.src);

    // 3. Reuse existing rect if possible
    _cachedRect ??= Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()
      ..color = color
      ..shader = shader
      ..blendMode = shader != null
          ? BlendMode.srcOver
          : BlendMode.src; // Optional: control how it blends

    canvas.drawRect(_cachedRect!, paint);
  }

// /// Compares two [ColorBackgroundDrawable]s for equality.
// @override
// bool operator ==(Object other) {
//   return other is ColorBackgroundDrawable && other.color == color;
// }
//
// @override
// int get hashCode => color.hashCode;
}

/// An extension on Color to create a background drawable easily.
extension ColorBackgroundDrawableGetter on Color {
  /// Returns an [ColorBackgroundDrawable] of the current [Color].
  ColorBackgroundDrawable get backgroundDrawable =>
      ColorBackgroundDrawable(color: this);
}
