import 'package:black_jack_21_flutter/core/exceptions/failure.dart';
import 'package:black_jack_21_flutter/core/permission/domain/errors/permission_errors.dart';
import 'package:black_jack_21_flutter/core/permission/domain/services/permission_service.dart';
import 'package:black_jack_21_flutter/modules/app_wrapper/domain/usecases/tracking_permission_request.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';

import 'tracking_permission_request_test.mocks.dart';

@GenerateMocks([
  PermissionService,
])
void main() {
  return group('TrackingPermissionRequest', () {
    final mockPermissionService = MockPermissionService();
    Future<Either<Failure, bool>> requestTrackingPermission() => mockPermissionService.requestTrackingPermission();

    final fakeAndroidPlatform = FakePlatform(operatingSystem: Platform.android);
    final fakeIOSPlatform = FakePlatform(operatingSystem: Platform.iOS);

    tearDown(() {
      reset(mockPermissionService);
    });

    test('call returns true when !Platform.isIOS', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => const Right(true));
      final result = await TrackingPermissionRequestImpl.withPlatform(
        mockPermissionService,
        fakeAndroidPlatform,
      ).call();

      expect(result, true);
      verifyZeroInteractions(mockPermissionService);
    });

    test('call returns true when requestTrackingPermission returns Right(true)', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => const Right(true));
      final result = await TrackingPermissionRequestImpl.withPlatform(mockPermissionService, fakeIOSPlatform).call();

      expect(result, true);
      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionService);
    });

    test('call returns false when requestTrackingPermission returns Right(false)', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => const Right(false));
      final result = await TrackingPermissionRequestImpl.withPlatform(mockPermissionService, fakeIOSPlatform).call();

      expect(result, false);
      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionService);
    });

    test('call returns false when requestTrackingPermission returns Left(failure)', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => Left(PermissionRequestError()));
      final result = await TrackingPermissionRequestImpl.withPlatform(mockPermissionService, fakeIOSPlatform).call();

      expect(result, false);
      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionService);
    });
  });
}
