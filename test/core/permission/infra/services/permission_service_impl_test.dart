import 'package:black_jack_21_flutter/core/permission/domain/errors/permission_errors.dart';
import 'package:black_jack_21_flutter/core/permission/infra/drivers/permission_driver.dart';
import 'package:black_jack_21_flutter/core/permission/infra/services/permission_service_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'permission_service_impl_test.mocks.dart';

@GenerateMocks([
  PermissionDriver,
])
void main() {
  return group('PermissionServiceImpl', () {
    final mockPermissionDriver = MockPermissionDriver();
    Future<bool> requestTrackingPermission() => mockPermissionDriver.requestTrackingPermission();

    tearDown(() {
      reset(mockPermissionDriver);
    });

    test('requestTrackingPermission returns Right(true) when permission request returns true', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => true);
      final result = await PermissionServiceImpl(mockPermissionDriver).requestTrackingPermission();

      expect(result, const Right(true));
      expect(result.getOrElse(() => false), true);
      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionDriver);
    });

    test('requestTrackingPermission returns Right(false) when permission request returns false', () async {
      when(requestTrackingPermission()).thenAnswer((_) async => false);
      final result = await PermissionServiceImpl(mockPermissionDriver).requestTrackingPermission();

      expect(result, const Right(false));
      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionDriver);
    });

    test('requestTrackingPermission returns Left(Failure) when permission request throws Exception', () async {
      when(requestTrackingPermission()).thenThrow(Exception());
      final result = await PermissionServiceImpl(mockPermissionDriver).requestTrackingPermission();
      result.fold(
        (left) => expect(left, isA<PermissionRequestError>()),
        (right) => expect(right, null),
      );

      verify(requestTrackingPermission());
      verifyNoMoreInteractions(mockPermissionDriver);
    });
  });
}
