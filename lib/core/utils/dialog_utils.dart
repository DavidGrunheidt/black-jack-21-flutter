import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../design_system/theme/custom_colors.dart';
import '../design_system/widgets/ignore_back_button.dart';

Future<bool?> showAppDialog({
  required BuildContext context,
  Widget? content,
  bool barrierDismissible = true,
  bool overrideOnConfirm = false,
  String? title,
  String? confirmText,
  String? cancelText,
  RouteSettings? routeSettings,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) async {
  if (!kIsWeb && Platform.isIOS) {
    return showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      routeSettings: routeSettings,
      builder: (context) {
        final dialog = CupertinoAlertDialog(
          title: title == null ? null : Text(title),
          content: content,
          actions: <Widget>[
            if (confirmText != null)
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: overrideOnConfirm
                    ? onConfirm
                    : () {
                        Navigator.pop(context, true);
                        onConfirm?.call();
                      },
                child: Text(confirmText),
              ),
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, false);
                  onCancel?.call();
                },
                child: Text(cancelText),
              ),
          ],
        );

        return IgnoreBackButton(dismissable: barrierDismissible, child: dialog);
      },
    );
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    routeSettings: routeSettings,
    builder: (context) {
      final dialog = AlertDialog(
        title: title == null ? null : Text(title),
        content: content,
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                onCancel?.call();
              },
              child: Text(cancelText.toUpperCase()),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: overrideOnConfirm
                  ? onConfirm
                  : () {
                      Navigator.pop(context, true);
                      onConfirm?.call();
                    },
              child: Text(confirmText.toUpperCase()),
            ),
        ],
      );

      return IgnoreBackButton(dismissable: barrierDismissible, child: dialog);
    },
  );
}

Future<void> showLoadingDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) => IgnoreBackButton(
      dismissable: false,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: CustomColors.white.value,
        ),
      ),
    ),
    useRootNavigator: false,
  );
}
