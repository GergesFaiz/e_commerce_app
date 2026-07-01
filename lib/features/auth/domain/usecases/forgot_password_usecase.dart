import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../repos/i_auth_repo.dart';

class ForgotPasswordUseCase extends BaseUseCase<String, String> {
  final IAuthRepo _repo;
  ForgotPasswordUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(String email) => _repo.forgotPassword(email);
}