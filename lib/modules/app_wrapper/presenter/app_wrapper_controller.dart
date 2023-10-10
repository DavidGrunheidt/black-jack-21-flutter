import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../domain/usecases/tracking_permission_request.dart';

part 'app_wrapper_controller.g.dart';

@singleton
class AppWrapperController = _AppWrapperController with _$AppWrapperController;

abstract class _AppWrapperController with Store {
  final TrackingPermissionRequest trackingPermissionRequestUseCase;

  const _AppWrapperController(
    this.trackingPermissionRequestUseCase,
  );
}
