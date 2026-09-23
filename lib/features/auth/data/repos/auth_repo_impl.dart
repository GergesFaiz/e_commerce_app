import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repos/i_auth_repo.dart';

class AuthRepoImpl implements IAuthRepo {
  final AuthRemoteDatasource _remote;
  final NetworkInfo _network;
  AuthRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final model = await _remote.login(email: email, password: password);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({required String name, required String email, required String password, required String phone}) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final model = await _remote.register(name: name, email: email, password: password, phone: phone);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final msg = await _remote.forgotPassword(email);
      return Right(msg);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() call) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await call());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetCode(String code) =>
      _guarded(() => _remote.verifyResetCode(code));

  @override
  Future<Either<Failure, String>> resetPassword({required String email, required String newPassword}) =>
      _guarded(() => _remote.resetPassword(email: email, newPassword: newPassword));

  @override
  Future<Either<Failure, String>> changeMyPassword({required String current, required String password}) =>
      _guarded(() => _remote.changeMyPassword(current: current, password: password));

  @override
  Future<Either<Failure, String>> updateMe({required String name, required String email, required String phone}) =>
      _guarded(() => _remote.updateMe(name: name, email: email, phone: phone));

  @override
  Future<Either<Failure, bool>> verifyToken(String token) =>
      _guarded(() => _remote.verifyToken(token));
}