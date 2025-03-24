
import 'package:flutter/cupertino.dart';

import 'background_drawable.dart';

/// Drawable to use a color as a background.
@immutable
class ColorBackgroundDrawable extends BackgroundDrawable {
  /// The color to be used as a background.
  final Color color;

  /// Optional shader to apply (e.g., gradient).
  final Shader? shader;

/// Creates a [ColorBackgroundDrawable] to use a color as a background.
  const ColorBackgroundDrawable({required this.color,
  this.shader,
  });

  /// Draws the background on the provided [canvas] of size [size].
  @override
  void draw(Canvas canvas, Size size) {
    // Draw the color onto the canvas
    canvas.drawColor(color, BlendMode.src);
    if(shader != null) {
      final paint = Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcOver; // Optional: control how it blends

      // 3. Draw the shader on top (covering full canvas)
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }

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
