import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'app_wrapper_controller.dart';

@RoutePage()
class AppWrapperPage extends StatefulWidget {
  const AppWrapperPage({
    super.key,
    this.controller,
  });

  final AppWrapperController? controller;

  @override
  State<AppWrapperPage> createState() => _AppWrapperPageState();
}

class _AppWrapperPageState extends State<AppWrapperPage> {
  late final AppWrapperController controller = widget.controller ?? AppWrapperController();

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
