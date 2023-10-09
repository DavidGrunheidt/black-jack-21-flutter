import 'package:dartz/dartz.dart';

import '../../../exceptions/failure.dart';

abstract class PermissionService {
  Future<Either<Failure, bool>> requestTrackingPermission();
}
