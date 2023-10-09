import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../../core/permission/domain/services/permission_service.dart';

abstract class TrackingPermissionRequest {
  Future<bool> call();
}

@Injectable(as: TrackingPermissionRequest)
class TrackingPermissionRequestImpl implements TrackingPermissionRequest {
  final PermissionService service;

  TrackingPermissionRequestImpl(this.service);

  @override
  Future<bool> call() async {
    if (Platform.isAndroid) return true;

    final result = await service.requestTrackingPermission();
    return result.getOrElse(() => false);
  }
}
