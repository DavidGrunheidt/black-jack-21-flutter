import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/dependencies/dependency_injector.dart';
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
  late final _controller = widget.controller ?? getIt<AppWrapperController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), _controller.trackingPermissionRequestUseCase);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
