import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../errors/errors.dart';

abstract class TrackingPermissionRequest {
  Future<Either<Failure, bool>> call();
}

@Injectable(as: TrackingPermissionRequest)
class TrackingPermissionRequestImpl implements TrackingPermissionRequest {
  @override
  Future<Either<Failure, bool>> call() async {
    return const Right(true);
  }
}
