import '../../../exceptions/failure.dart';

class PermissionRequestError extends Failure {
  PermissionRequestError({
    super.message = 'Houve um erro durante a solicitação de permissões',
    super.error,
    super.stack,
  });

  @override
  String get code => 'PERMISSION_REQUEST_ERROR';
}
