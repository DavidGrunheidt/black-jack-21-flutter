import 'package:injectable/injectable.dart';
import 'package:platform/platform.dart';

import '../../../../core/permission/domain/services/permission_service.dart';

abstract class TrackingPermissionRequest {
  Future<bool> call();
}

@Injectable(as: TrackingPermissionRequest)
class TrackingPermissionRequestImpl implements TrackingPermissionRequest {
  final PermissionService service;
  final Platform _platform;

  @factoryMethod
  TrackingPermissionRequestImpl(this.service) : _platform = const LocalPlatform();

  TrackingPermissionRequestImpl.withPlatform(this.service, this._platform);

  @override
  Future<bool> call() async {
    if (!_platform.isIOS) return true;

    final result = await service.requestTrackingPermission();
    return result.getOrElse(() => false);
  }
}
