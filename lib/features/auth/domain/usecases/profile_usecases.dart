import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../repos/i_auth_repo.dart';

class VerifyResetCodeUseCase extends BaseUseCase<String, String> {
  final IAuthRepo _repo;
  VerifyResetCodeUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(String code) => _repo.verifyResetCode(code);
}

class ResetPasswordParams {
  final String email;
  final String newPassword;
  const ResetPasswordParams({required this.email, required this.newPassword});
}

class ResetPasswordUseCase extends BaseUseCase<String, ResetPasswordParams> {
  final IAuthRepo _repo;
  ResetPasswordUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(ResetPasswordParams p) =>
      _repo.resetPassword(email: p.email, newPassword: p.newPassword);
}

class ChangePasswordParams {
  final String current;
  final String password;
  const ChangePasswordParams({required this.current, required this.password});
}

class ChangePasswordUseCase extends BaseUseCase<String, ChangePasswordParams> {
  final IAuthRepo _repo;
  ChangePasswordUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(ChangePasswordParams p) =>
      _repo.changeMyPassword(current: p.current, password: p.password);
}

class UpdateProfileParams {
  final String name;
  final String email;
  final String phone;
  const UpdateProfileParams({required this.name, required this.email, required this.phone});
}

class UpdateProfileUseCase extends BaseUseCase<String, UpdateProfileParams> {
  final IAuthRepo _repo;
  UpdateProfileUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(UpdateProfileParams p) =>
      _repo.updateMe(name: p.name, email: p.email, phone: p.phone);
}

class VerifyTokenUseCase extends BaseUseCase<bool, String> {
  final IAuthRepo _repo;
  VerifyTokenUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String token) => _repo.verifyToken(token);
}
