import 'package:flutter/material.dart';
import 'object_drawable.dart';
import 'text_drawable.dart';
import 'dart:math';

enum HandleType {
  left, right, top, bottom,
  topLeft, topRight, bottomLeft, bottomRight,
  rotate,
}

class SelectableObjectDrawable extends ObjectDrawable {
  ObjectDrawable drawable;

  final double handleSize = 12.0;
  final double rotateHandleDistance = 30;

  final Paint borderPaint = Paint()
    ..color = const Color(0xFF9C27B0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint handlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  final Paint handleBorderPaint = Paint()
    ..color = const Color(0xFF9C27B0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  SelectableObjectDrawable({
    required this.drawable,
  }) : super(
    position: drawable.position,
    scale: drawable.scale,
    rotationAngle: drawable.rotationAngle,
    assists: drawable.assists,
    locked: drawable.locked,
    hidden: drawable.hidden,
  );

  Rect get bounds {
    final size = drawable.getSize();
    final scaledSize = Size(size.width * scale, size.height * scale);
    return Rect.fromCenter(center: position, width: scaledSize.width, height: scaledSize.height);
  }

  @override
  void draw(Canvas canvas, Size size) {
    super.draw(canvas, size);

    drawable.drawObject(canvas, size); // draw main object

    final b = bounds;

    // Border
    canvas.drawRect(b, borderPaint);

    // Handles
    for (var handle in HandleType.values) {
      final offset = _handleOffset(handle, b);
      final isRotate = handle == HandleType.rotate;
      final radius = isRotate ? handleSize : handleSize / 2;

      canvas.drawCircle(offset, radius.toDouble(), handlePaint);
      canvas.drawCircle(offset, radius.toDouble(), handleBorderPaint);
    }
  }

  Offset _handleOffset(HandleType type, Rect b) {
    switch (type) {
      case HandleType.left: return Offset(b.left, b.center.dy);
      case HandleType.right: return Offset(b.right, b.center.dy);
      case HandleType.top: return Offset(b.center.dx, b.top);
      case HandleType.bottom: return Offset(b.center.dx, b.bottom);
      case HandleType.topLeft: return b.topLeft;
      case HandleType.topRight: return b.topRight;
      case HandleType.bottomLeft: return b.bottomLeft;
      case HandleType.bottomRight: return b.bottomRight;
      case HandleType.rotate: return Offset(b.center.dx, b.top - rotateHandleDistance);
    }
  }

  HandleType? hitTestHandle(Offset point) {
    for (var handle in HandleType.values) {
      final offset = _handleOffset(handle, bounds);
      final area = Rect.fromCircle(center: offset, radius: handleSize);
      if (area.contains(point)) return handle;
    }
    return null;
  }

  void onPanUpdate(HandleType handle, DragUpdateDetails details) {
    if (handle == HandleType.rotate) {
      _rotate(details.localPosition);
    } else {
      _stretchOrScale(handle, details.delta);
    }
  }

  void _rotate(Offset cursor) {
    final center = position;
    final angle = atan2(cursor.dy - center.dy, cursor.dx - center.dx);
    drawable = drawable.copyWith(rotation: angle);
  }

  void _stretchOrScale(HandleType handle, Offset delta) {
    final size = drawable.getSize();
    Offset newPos = drawable.position;
    double scaleX = drawable.scale;
    double scaleY = drawable.scale;

    final dx = delta.dx;
    final dy = delta.dy;

    if (handle == HandleType.left) {
      scaleX += -dx / size.width;
      newPos = newPos.translate(dx / 2, 0);
    } else if (handle == HandleType.right) {
      scaleX += dx / size.width;
      newPos = newPos.translate(dx / 2, 0);
    } else if (handle == HandleType.top) {
      scaleY += -dy / size.height;
      newPos = newPos.translate(0, dy / 2);
    } else if (handle == HandleType.bottom) {
      scaleY += dy / size.height;
      newPos = newPos.translate(0, dy / 2);
    } else {
      // For corners, apply uniform scale
      final avg = (dx + dy) / 2;
      scaleX = scaleY = (size.width + avg) / size.width;
    }

    final avgScale = (scaleX + scaleY) / 2;
    drawable = drawable.copyWith(scale: avgScale, position: newPos);
  }

  @override
  void drawObject(Canvas canvas, Size size) {
    drawable.drawObject(canvas, size);
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return drawable.getSize(minWidth: minWidth, maxWidth: maxWidth);
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
        hidden: hidden ?? drawable.hidden,
        assists: assists ?? drawable.assists,
        position: position ?? drawable.position,
        rotation: rotation ?? drawable.rotationAngle,
        scale: scale ?? drawable.scale,
        locked: locked ?? drawable.locked,
      ),
    );
  }
}

/*
enum HandleType {
  left, right, top, bottom,
  topLeft, topRight, bottomLeft, bottomRight,
  rotate
}
class SelectableObjectDrawable extends ObjectDrawable {
  ObjectDrawable drawable;

  final double handleRadius = 8.0;

  final Paint borderPaint = Paint()
    ..color = Color(0xFF9C27B0) // Purple
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint handlePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  final Paint handleBorderPaint = Paint()
    ..color = Color(0xFF9C27B0)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  SelectableObjectDrawable({
    required this.drawable,
  }) : super(
    position: drawable.position,
    scale: drawable.scale,
    rotationAngle: drawable.rotationAngle,
    assists: drawable.assists,
    locked: drawable.locked,
    hidden: drawable.hidden,
  );

  Rect get bounds {
    final size = drawable.getSize();
    final scaledSize = Size(size.width * scale, size.height * scale);
    return Rect.fromCenter(center: position, width: scaledSize.width, height: scaledSize.height);
  }

  @override
  void draw(Canvas canvas, Size size) {
    // 1. Draw assist lines
    super.draw(canvas, size);

    // 2. Draw original object
    drawable.drawObject(canvas, size);

    // 3. Draw purple border around object
    final b = bounds;
    canvas.drawRect(b, borderPaint);

    // 4. Draw 8 circular handles
    for (var handle in HandleType.values.where((h) => h != HandleType.rotate)) {
      final offset = _handleOffset(handle, b);

      canvas.drawCircle(offset, handleRadius, handlePaint);         // Fill
      canvas.drawCircle(offset, handleRadius, handleBorderPaint);   // Border
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

  @override
  void drawObject(Canvas canvas, Size size) {

    // super.draw(canvas, size);
    drawable.drawAssists(canvas, size);

    // drawable.drawObject(canvas, size);
    // 3. Draw purple border around object
    final b = bounds;
    canvas.drawRect(b, borderPaint);

    // 4. Draw 8 circular handles
    for (var handle in HandleType.values.where((h) => h != HandleType.rotate)) {
      final offset = _handleOffset(handle, b);

      canvas.drawCircle(offset, handleRadius, handlePaint);         // Fill
      canvas.drawCircle(offset, handleRadius, handleBorderPaint);   // Border
    }
    canvas.restore();
  }

  @override
  Size getSize({double minWidth = 0.0, double maxWidth = double.infinity}) {
    return drawable.getSize(minWidth: minWidth, maxWidth: maxWidth);
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
        hidden: hidden ?? this.hidden,
        assists: assists ?? drawable.assists,
        position: position ?? drawable.position,
        rotation: rotation ?? drawable.rotationAngle,
        scale: scale ?? drawable.scale,
        locked: locked ?? drawable.locked,
      ),
    );
  }
}

/*
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
*/*/