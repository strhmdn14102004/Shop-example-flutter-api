
import "package:flutter/material.dart";
import "package:shop/helper/navigator.dart";
import "package:shop/overlay/error_overlay.dart";
import "package:shop/overlay/success_overlay.dart";


class Overlays {
  static Future<void> error({
    required String message,
  }) async {
    if (Navigators.navigatorState.currentContext != null) {
      await Navigator.of(Navigators.navigatorState.currentContext!).push(
        ErrorOverlay(
          message: message,
        ),
      );
    }
  }

  static Future<void> success({
    required String message,
  }) async {
    if (Navigators.navigatorState.currentContext != null) {
      await Navigator.of(Navigators.navigatorState.currentContext!).push(
        SuccessOverlay(
          message: message,
        ),
      );
    }
  }
}
