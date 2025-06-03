import 'dart:ui';
import 'object_drawable.dart';

/// A drawable of an image as an object.
class ImageDrawable extends ObjectDrawable {
  /// The image to be drawn.
  final Image image;

  /// Whether the image is flipped or not.
  final bool flipped;

  final Path? clipPath;

  /// Optional shader to apply (e.g., gradient).
  final Shader? shader;

  /// Optional image filter (e.g., blur).
  final ImageFilter? imageFilter;

  /// Optional color filter (e.g., grayscale, tint).
  final ColorFilter? colorFilter;

  /// Filter quality for scaling the image.
  final FilterQuality filterQuality;

  final String? id;

  /// Creates an [ImageDrawable] with the given [image].
  ImageDrawable({
    required Offset position,
    double rotationAngle = 0,
    double scale = 1,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
    Map<ObjectDrawableAssist, Paint> assistPaints =
        const <ObjectDrawableAssist, Paint>{},
    bool locked = false,
    bool hidden = false,
    required this.image,
    this.flipped = false,
    this.shader,
    this.imageFilter,
    this.colorFilter,
    this.filterQuality = FilterQuality.low,
    this.clipPath,
    this.id,
  }) : super(
          position: position,
          rotationAngle: rotationAngle,
          scale: scale,
          assists: assists,
          assistPaints: assistPaints,
          hidden: hidden,
          locked: locked,
        );

  /// Creates an [ImageDrawable] with the given [image], and calculates the scale based on the given [size].
  /// The scale will be calculated such that the size of the drawable fits into the provided size.
  ///
  /// For example, if the image was 512x256 and the provided size was 128x128, the scale would be 0.25,
  /// fitting the width of the image into the size (128x64).
  ImageDrawable.fittedToSize({
    required Offset position,
    required Size size,
    double rotationAngle = 0,
    Set<ObjectDrawableAssist> assists = const <ObjectDrawableAssist>{},
    Map<ObjectDrawableAssist, Paint> assistPaints =
        const <ObjectDrawableAssist, Paint>{},
    bool locked = false,
    bool hidden = false,
    required Image image,
    bool flipped = false,
    String? id,
  }) : this(
          position: position,
          rotationAngle: rotationAngle,
          scale: _calculateScaleFittedToSize(image, size),
          assists: assists,
          assistPaints: assistPaints,
          image: image,
          flipped: flipped,
          hidden: hidden,
          locked: locked,
          id: id,
        );

  /// Creates a copy of this but with the given fields replaced with the new values.
  @override
  ImageDrawable copyWith({
    String? id,
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    Image? image,
    bool? flipped,
    bool? locked,
    Shader? shader,
    ImageFilter? imageFilter,
    ColorFilter? colorFilter,
    FilterQuality? filterQuality,
    Path? clipPath,
  }) {
    return ImageDrawable(
      id: id ?? this.id,
      hidden: hidden ?? this.hidden,
      assists: assists ?? this.assists,
      position: position ?? this.position,
      rotationAngle: rotation ?? rotationAngle,
      scale: scale ?? this.scale,
      image: image ?? this.image,
      flipped: flipped ?? this.flipped,
      locked: locked ?? this.locked,
      shader: shader ?? this.shader,
      imageFilter: imageFilter ?? this.imageFilter,
      colorFilter: colorFilter ?? this.colorFilter,
      filterQuality: filterQuality ?? this.filterQuality,
      clipPath: clipPath ?? this.clipPath,
    );
  }

  /// Draws the image on the provided [canvas] of size [size].
  @override
  void drawObject(Canvas canvas, Size size) {
    final scaledSize =
        Offset(image.width.toDouble(), image.height.toDouble()) * scale;
    final position = this.position.scale(flipped ? -1 : 1, 1);

    if (flipped) canvas.scale(-1, 1);
    canvas.save();
    final paint = Paint()
      ..color =
          const Color.fromRGBO(10, 10, 10, 0.9) // Set the color for the path
      ..filterQuality = filterQuality
      ..style = PaintingStyle.fill
      ..strokeWidth = 10.0;

    // Apply clipping if clipPath is provided
    if (clipPath != null) {
      canvas.drawPath(clipPath!, paint);
      // Assuming clipPath is relative to the drawable's local coordinate space centered at (0,0)
      canvas.clipPath(clipPath!, doAntiAlias: true);
    }

    // Draw the image onto the canvas.
    canvas.drawImageRect(
        image,
        Rect.fromPoints(Offset.zero,
            Offset(image.width.toDouble(), image.height.toDouble())),
        Rect.fromPoints(position - scaledSize / 2, position + scaledSize / 2),
        Paint());

    canvas.restore();
  }

  /// Calculates the size of the rendered object.
  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return Size(
      image.width * scale,
      image.height * scale,
    );
  }

  /// Compares two [ImageDrawable]s for equality.
  // @override
  // bool operator ==(Object other) {
  //   return other is ImageDrawable &&
  //       super == other &&
  //       other.image == image;
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
  //     image);

  static double _calculateScaleFittedToSize(Image image, Size size) {
    if (image.width >= image.height) {
      return size.width / image.width;
    } else {
      return size.height / image.height;
    }
  }
}
