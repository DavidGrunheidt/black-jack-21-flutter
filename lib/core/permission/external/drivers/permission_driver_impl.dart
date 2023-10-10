import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../infra/drivers/permission_driver.dart';

@Injectable(as: PermissionDriver)
class PermissionDriverImpl implements PermissionDriver {
  @override
  Future<bool> requestTrackingPermission() async {
    final permissionStatus = await Permission.appTrackingTransparency.request();
    return permissionStatus.isGranted;
  }
}
