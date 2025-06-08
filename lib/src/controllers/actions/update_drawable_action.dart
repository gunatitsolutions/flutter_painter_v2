import 'package:flutter/foundation.dart';

import '../drawables/drawable.dart';
import '../painter_controller.dart';
import 'action.dart';

/// An action that replaces the entire list of drawables in the [PainterController].
class UpdateDrawablesAction extends ControllerAction<bool, bool> {
  /// The previous list of drawables (before update).
  final List<Drawable> oldDrawables;

  /// The new list of drawables (after update).
  final List<Drawable> newDrawables;

  UpdateDrawablesAction(this.oldDrawables, this.newDrawables);

  @protected
  @override
  bool perform$(PainterController controller) {
    controller.value = controller.value.copyWith(
      drawables: List<Drawable>.from(newDrawables),
    );
    return true;
  }

  @protected
  @override
  bool unperform$(PainterController controller) {
    controller.value = controller.value.copyWith(
      drawables: List<Drawable>.from(oldDrawables),
    );
    return true;
  }

  @protected
  @override
  ControllerAction? merge$(ControllerAction previousAction) {
    if (previousAction is UpdateDrawablesAction) {
      // Replace previous oldDrawables with the one before it, and this newDrawables remains latest
      return UpdateDrawablesAction(
        previousAction.oldDrawables,
        newDrawables,
      );
    }
    return super.merge$(previousAction);
  }
}
