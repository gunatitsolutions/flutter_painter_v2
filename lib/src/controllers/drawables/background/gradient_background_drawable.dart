import 'package:flutter/material.dart';
import 'background_drawable.dart';

enum GradientType {
  solid,
  linear,
  radial,
  sweep,
}

/// A drawable background with a gradient fill.
///
/// Use this to render a gradient background in the Flutter Painter canvas.
class GradientBackgroundDrawable extends BackgroundDrawable {
  /// The gradient to fill the background with.
  final GradientType gradientType;
  final List<Color> colors;

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final AlignmentGeometry center;
  final double radius;

  final Shader? shader;

  /// Cached size used for optimizing shader creation.
  Size? _lastSize;

  /// Cached shader for the given size.
  Shader? _cachedShader;

  Rect? _cachedRect;

  /// Creates a new gradient background drawable.
  GradientBackgroundDrawable({
    required this.colors,
    required this.gradientType,
    this.shader,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.center = Alignment.center,
    this.radius = 0.5,
  });

  @override
  void draw(Canvas canvas, Size size) {
    _cachedRect ??= Rect.fromLTWH(0, 0, size.width, size.height);
    var paint = Paint();
    if (_lastSize != size || _cachedShader == null) {
      final gradient = gradientType.toGradient(
        colors: colors,
        begin: begin,
        end: end,
        center: center,
        radius: radius,
      );
      _cachedShader = gradient.createShader(_cachedRect!);
      _lastSize = size;
    }
    if (colors.length == 1) {
      paint = Paint()
        ..color = colors.first
        ..style = PaintingStyle.fill;
    } else {
      paint = Paint()
        ..shader = _cachedShader
        ..style = PaintingStyle.fill;
    }

    canvas.drawRect(_cachedRect!, paint);

    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    //
    // if (_lastSize != size || _cachedShader == null) {
    //   final gradient = gradientType.toGradient(
    //     colors: colors,
    //     begin: begin,
    //     end: end,
    //     center: center,
    //     radius: radius,
    //   );
    //   _cachedShader = gradient.createShader(rect);
    //   _lastSize = size;
    // }
    //
    // final paint = Paint()
    //   ..shader = _cachedShader!
    //   ..style = PaintingStyle.fill;
    //
    // canvas.drawRect(rect, paint);
  }

  GradientBackgroundDrawable copyWith({
    GradientType? gradientType,
    List<Color>? colors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    AlignmentGeometry? center,
    double? radius,
  }) {
    return GradientBackgroundDrawable(
      gradientType: gradientType ?? this.gradientType,
      colors: colors ?? this.colors,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      center: center ?? this.center,
      radius: radius ?? this.radius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradientBackgroundDrawable &&
          runtimeType == other.runtimeType &&
          gradientType == other.gradientType &&
          _listEquals(colors, other.colors) &&
          begin == other.begin &&
          end == other.end &&
          center == other.center &&
          radius == other.radius;

  @override
  int get hashCode => Object.hash(
        gradientType,
        Object.hashAll(colors),
        begin,
        end,
        center,
        radius,
      );
}

extension GradientTypeExtension on GradientType {
  Gradient toGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
  }) {
    switch (this) {
      case GradientType.linear:
        return LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        );
      case GradientType.radial:
        return RadialGradient(
          colors: colors,
          center: center,
          radius: radius,
        );
      case GradientType.sweep:
        return SweepGradient(
          colors: colors,
          center: center,
        );
      case GradientType.solid:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Gradient toGradients({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
  }) {
    switch (this) {
      case GradientType.linear:
        return LinearGradient(colors: colors, begin: begin, end: end);
      case GradientType.radial:
        return RadialGradient(colors: colors, center: center, radius: radius);
      case GradientType.sweep:
        return SweepGradient(colors: colors, center: center);
      case GradientType.solid:
      default:
        return LinearGradient(colors: [colors.first, colors.first]);
    }
  }
}

/// Utility function for comparing two color lists.
bool _listEquals(List<Color> a, List<Color> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

extension GradientBackgroundDrawableGetter on List<Color> {
  /// Returns a [GradientBackgroundDrawable] using the current list of colors.
  /// Defaults to `GradientType.linear` if not specified.
  GradientBackgroundDrawable gradientDrawable({
    GradientType type = GradientType.linear,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
  }) {
    return GradientBackgroundDrawable(
      gradientType: type,
      colors: this,
      begin: begin,
      end: end,
      center: center,
      radius: radius,
    );
  }
}
