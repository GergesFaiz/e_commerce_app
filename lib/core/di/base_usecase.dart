import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class BaseUseCase<Output, Input> {
  Future<Either<Failure, Output>> call(Input input);
}

class NoParams {}
