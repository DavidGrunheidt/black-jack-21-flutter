import 'package:flutter/material.dart';

class IgnoreBackButton extends StatelessWidget {
  final bool dismissable;
  final Widget child;

  const IgnoreBackButton({
    super.key,
    required this.dismissable,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return dismissable ? child : WillPopScope(onWillPop: () async => false, child: child);
  }
}
