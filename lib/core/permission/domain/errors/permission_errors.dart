import '../../../exceptions/failure.dart';

class PermissionRequestError extends Failure {
  PermissionRequestError({
    this.message = 'Houve um erro durante a solicitação de permissões',
  });

  @override
  String get code => 'PERMISSION_REQUEST_ERROR';

  @override
  final String message;
}
