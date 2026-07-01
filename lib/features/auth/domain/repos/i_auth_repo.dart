import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';

abstract class IAuthRepo {
  Future<Either<Failure, UserEntity>> login({required String email, required String password});
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password, required String phone});
  Future<Either<Failure, String>> forgotPassword(String email);
}