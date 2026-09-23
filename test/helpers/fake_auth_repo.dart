import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/repos/i_auth_repo.dart';

/// In-memory [IAuthRepo] fake used by unit and widget tests.
///
/// Returns [loginResult] for login/register unless [loginGate] is provided,
/// in which case the future stays pending until the test completes it
/// (useful for asserting loading UI states).
class FakeAuthRepo implements IAuthRepo {
  FakeAuthRepo(this.loginResult, {this.loginGate});

  final Either<Failure, UserEntity> loginResult;
  final Completer<Either<Failure, UserEntity>>? loginGate;

  int loginCalls = 0;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) {
    loginCalls++;
    lastEmail = email;
    lastPassword = password;
    if (loginGate != null) return loginGate!.future;
    return Future.value(loginResult);
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return Future.value(loginResult);
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    return const Right('Reset instructions sent');
  }

  @override
  Future<Either<Failure, String>> verifyResetCode(String code) async {
    return const Right('Code verified');
  }

  @override
  Future<Either<Failure, String>> resetPassword({required String email, required String newPassword}) async {
    return const Right('Password reset successfully');
  }

  @override
  Future<Either<Failure, String>> changeMyPassword({required String current, required String password}) async {
    return const Right('Password updated');
  }

  @override
  Future<Either<Failure, String>> updateMe({required String name, required String email, required String phone}) async {
    return const Right('Profile updated');
  }

  @override
  Future<Either<Failure, bool>> verifyToken(String token) async {
    return const Right(true);
  }
}