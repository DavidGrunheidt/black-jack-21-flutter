import 'package:dartz/dartz.dart';

extension DartzUtils<L, R> on Either<L, R> {
  R get rightValue => (this as Right).value;
  L get leftValue => (this as Left).value;
}
