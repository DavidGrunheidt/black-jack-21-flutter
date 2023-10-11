abstract class Failure implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stack;

  String get code;

  const Failure({
    required this.message,
    this.error,
    this.stack,
  });
}
