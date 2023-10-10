import 'package:black_jack_21_flutter/core/permission/external/drivers/permission_driver_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'permission_driver_impl_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    // ignore: deprecated_member_use
    MockSpec<PermissionHandlerPlatform>(mixingIn: [MockPlatformInterfaceMixin])
  ],
)
void main() {
  return group('PermissionDriverImpl', () {
    final mockPermissionHandlerPlatform = MockPermissionHandlerPlatform();
    PermissionHandlerPlatform.instance = mockPermissionHandlerPlatform;

    const trackingPermission = Permission.appTrackingTransparency;
    Future<Map<Permission, PermissionStatus>> requestAppTrackingTransparencyPermission() {
      return mockPermissionHandlerPlatform.requestPermissions([trackingPermission]);
    }

    tearDown(() {
      reset(mockPermissionHandlerPlatform);
    });

    final deniedPermissions = [
      PermissionStatus.denied,
      PermissionStatus.restricted,
      PermissionStatus.limited,
      PermissionStatus.permanentlyDenied,
      PermissionStatus.provisional,
    ];

    for (final permission in deniedPermissions) {
      test('requestTrackingPermission returns false when ${permission.name}', () async {
        when(requestAppTrackingTransparencyPermission()).thenAnswer((_) async {
          return {trackingPermission: PermissionStatus.denied};
        });

        final result = await PermissionDriverImpl().requestTrackingPermission();

        expect(result, false);
        verify(requestAppTrackingTransparencyPermission());
        verifyNoMoreInteractions(mockPermissionHandlerPlatform);
      });
    }

    test('requestTrackingPermission returns true when permissionStatus.granted', () async {
      when(requestAppTrackingTransparencyPermission()).thenAnswer((_) async {
        return {trackingPermission: PermissionStatus.granted};
      });

      final result = await PermissionDriverImpl().requestTrackingPermission();

      expect(result, true);
      verify(requestAppTrackingTransparencyPermission());
      verifyNoMoreInteractions(mockPermissionHandlerPlatform);
    });
  });
}
