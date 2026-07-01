import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repos/i_auth_repo.dart';

class RegisterParams {
  final String name, email, password, phone;
  const RegisterParams({required this.name, required this.email, required this.password, required this.phone});
}

class RegisterUseCase extends BaseUseCase<UserEntity, RegisterParams> {
  final IAuthRepo _repo;
  RegisterUseCase(this._repo);
  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams p) =>
      _repo.register(name: p.name, email: p.email, password: p.password, phone: p.phone);
}