import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../exceptions/failure.dart';
import '../../domain/errors/permission_errors.dart';
import '../../domain/services/permission_service.dart';
import '../drivers/permission_driver.dart';

@Injectable(as: PermissionService)
class PermissionServiceImpl implements PermissionService {
  final PermissionDriver driver;

  const PermissionServiceImpl(this.driver);

  @override
  Future<Either<Failure, bool>> requestTrackingPermission() async {
    try {
      final status = await driver.requestTrackingPermission();
      return Right(status);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(PermissionRequestError());
    }
  }
}
