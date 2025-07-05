import 'package:flutter_painter_v2/src/controllers/painter_controller.dart';
import 'package:flutter_painter_v2/src/controllers/actions/action.dart';
import 'package:flutter_painter_v2/src/controllers/drawables/drawable.dart';

class ReorderDrawableAction extends ControllerAction<bool, bool> {
  final int oldIndex;
  final int newIndex;

  ReorderDrawableAction(this.oldIndex, this.newIndex);

  @override
  bool perform$(PainterController controller) {
    final drawables = List<Drawable>.from(controller.value.drawables);

    // Index validation
    if (oldIndex < 0 ||
        oldIndex >= drawables.length ||
        newIndex < 0 ||
        newIndex >= drawables.length) {
      return false;
    }

    final drawable = drawables.removeAt(oldIndex);
    drawables.insert(newIndex, drawable);

    controller.value = controller.value.copyWith(drawables: drawables);
    return true;
  }

  @override
  bool unperform$(PainterController controller) {
    final drawables = List<Drawable>.from(controller.value.drawables);

    // Edge case: If drawing list has changed or index out of range
    if (newIndex < 0 ||
        newIndex >= drawables.length ||
        oldIndex < 0 ||
        oldIndex > drawables.length) {
      return false;
    }

    final drawable = drawables.removeAt(newIndex);
    drawables.insert(oldIndex, drawable);

    controller.value = controller.value.copyWith(drawables: drawables);
    return true;
  }

  @override
  ControllerAction? merge$(ControllerAction previousAction) {
    // Reordering doesn't make sense to merge for now
    return null;
  }
}
