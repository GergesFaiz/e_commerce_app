import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repos/i_auth_repo.dart';

class LoginParams {
  final String email, password;
  const LoginParams({required this.email, required this.password});
}

class LoginUseCase extends BaseUseCase<UserEntity, LoginParams> {
  final IAuthRepo _repo;
  LoginUseCase(this._repo);
  @override
  Future<Either<Failure, UserEntity>> call(LoginParams p) =>
      _repo.login(email: p.email, password: p.password);
}