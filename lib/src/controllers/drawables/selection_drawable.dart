import 'package:flutter/material.dart';
import 'object_drawable.dart';
import 'text_drawable.dart';
import 'dart:math';

enum HandleType {
  left, right, top, bottom,
  topLeft, topRight, bottomLeft, bottomRight,
  rotate
}

class SelectableObjectDrawable extends ObjectDrawable {
  ObjectDrawable drawable;
  final double handleSize;
  final Paint handlePaint;
  final Paint borderPaint;

  SelectableObjectDrawable({
    required this.drawable,
    this.handleSize = 12,
  })  : handlePaint = Paint()..color = Colors.blueAccent,
        borderPaint = Paint()
          ..color = Colors.blueAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
        super(position: drawable.position, scale: drawable.scale, rotationAngle: drawable.rotationAngle);

  Rect get bounds {
    final size = drawable.getSize();
    return Rect.fromCenter(center: drawable.position, width: size.width * drawable.scale, height: size.height * drawable.scale);
  }

  @override
  void draw(Canvas canvas, Size size) {
    drawable.draw(canvas, size); // Draw original object
    final b = bounds;

    // Draw border
    canvas.drawRect(b, borderPaint);

    // Draw resize handles
    for (var handle in HandleType.values) {
      if (handle == HandleType.rotate) {
        final offset = Offset(b.center.dx, b.top - 30);
        canvas.drawCircle(offset, handleSize / 2, handlePaint);
      } else {
        final offset = _handleOffset(handle, b);
        canvas.drawRect(
          Rect.fromCenter(center: offset, width: handleSize, height: handleSize),
          handlePaint,
        );
      }
    }
  }

  Offset _handleOffset(HandleType type, Rect b) {
    switch (type) {
      case HandleType.left:
        return Offset(b.left, b.center.dy);
      case HandleType.right:
        return Offset(b.right, b.center.dy);
      case HandleType.top:
        return Offset(b.center.dx, b.top);
      case HandleType.bottom:
        return Offset(b.center.dx, b.bottom);
      case HandleType.topLeft:
        return b.topLeft;
      case HandleType.topRight:
        return b.topRight;
      case HandleType.bottomLeft:
        return b.bottomLeft;
      case HandleType.bottomRight:
        return b.bottomRight;
      case HandleType.rotate:
        return Offset(b.center.dx, b.top - 30);
    }
  }

  HandleType? hitTestHandle(Offset point) {
    for (var handle in HandleType.values) {
      final offset = _handleOffset(handle, bounds);
      final area = handle == HandleType.rotate
          ? Rect.fromCircle(center: offset, radius: handleSize)
          : Rect.fromCenter(center: offset, width: handleSize, height: handleSize);
      if (area.contains(point)) return handle;
    }
    return null;
  }

  void onPanUpdate(HandleType handle, DragUpdateDetails details) {
    if (handle == HandleType.rotate) {
      _rotate(details.localPosition);
    } else if (drawable is TextDrawable) {
      _resizeTextDrawable(handle, details.delta.dx, details.delta.dy);
    } else {
      _resizeGeneric(handle, details.delta.dx, details.delta.dy);
    }
  }

  void _rotate(Offset cursorPosition) {
    final center = drawable.position;
    final angle = atan2(cursorPosition.dy - center.dy, cursorPosition.dx - center.dx);
    drawable = drawable.copyWith(rotation: angle);
  }

  void _resizeTextDrawable(HandleType handle, double dx, double dy) {
    var textD = drawable as TextDrawable;
    final currentSize = textD.getSize();
    double newWidth = currentSize.width;
    double newHeight = currentSize.height;

    if ([HandleType.left, HandleType.topLeft, HandleType.bottomLeft].contains(handle)) newWidth -= dx;
    if ([HandleType.right, HandleType.topRight, HandleType.bottomRight].contains(handle)) newWidth += dx;

    if ([HandleType.top, HandleType.topLeft, HandleType.topRight].contains(handle)) newHeight -= dy;
    if ([HandleType.bottom, HandleType.bottomLeft, HandleType.bottomRight].contains(handle)) newHeight += dy;

    if (newWidth <= textD.style.fontSize! * 5) {
      textD = textD.copyWith(maxLines: 1, softWrap: false);
    } else {
      textD = textD.copyWith(maxLines: null, softWrap: true);
    }

    drawable = textD.copyWith(position: drawable.position, scale: 1);
  }

  void _resizeGeneric(HandleType handle, double dx, double dy) {
    final size = drawable.getSize();
    double newScaleX = drawable.scale;
    double newScaleY = drawable.scale;

    if ([HandleType.left, HandleType.right].contains(handle)) {
      newScaleX += (handle == HandleType.left ? -dx : dx) / size.width;
    } else if ([HandleType.top, HandleType.bottom].contains(handle)) {
      newScaleY += (handle == HandleType.top ? -dy : dy) / size.height;
    } else {
      final avg = (dx + dy) / 2;
      newScaleX = newScaleY = (size.width + avg) / size.width;
    }

    drawable = drawable.copyWith(scale: (newScaleX + newScaleY) / 2);
  }

  @override
  ObjectDrawable copyWith({
    bool? hidden,
    Set<ObjectDrawableAssist>? assists,
    Offset? position,
    double? rotation,
    double? scale,
    bool? locked,
  }) {
    return SelectableObjectDrawable(
      drawable: drawable.copyWith(
        position: position ?? drawable.position,
        rotation: rotation ?? drawable.rotationAngle,
        scale: scale ?? drawable.scale,
        hidden: hidden ?? drawable.hidden,
        locked: locked ?? drawable.locked,
        assists: assists ?? drawable.assists,
      ),
    );
  }

  @override
  void drawObject(Canvas canvas, Size size) {
    // drawable.draw(canvas, size);
    drawable.draw(canvas, size); // Draw original object
    final b = bounds;

    // Draw border
    canvas.drawRect(b, borderPaint);

    // Draw resize handles
    for (var handle in HandleType.values) {
      if (handle == HandleType.rotate) {
        final offset = Offset(b.center.dx, b.top - 30);
        canvas.drawCircle(offset, handleSize / 2, handlePaint);
      } else {
        final offset = _handleOffset(handle, b);
        canvas.drawRect(
          Rect.fromCenter(center: offset, width: handleSize, height: handleSize),
          handlePaint,
        );
      }
    }

  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return drawable.getSize(minWidth: minWidth, maxWidth: maxWidth);
  }
}
