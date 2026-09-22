import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_repo.dart';

void main() {
  const user = UserEntity(
    name: 'Gerges Faiz',
    email: 'gerges@example.com',
    token: 'jwt-token',
    id: 'u1',
  );

  test('returns the user when login succeeds and forwards credentials',
      () async {
    final repo = FakeAuthRepo(const Right(user));
    final useCase = LoginUseCase(repo);

    final result =
        await useCase(const LoginParams(email: 'gerges@example.com', password: 's3cret'));

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => throw StateError('expected Right')), same(user));
    expect(repo.loginCalls, 1);
    expect(repo.lastEmail, 'gerges@example.com');
    expect(repo.lastPassword, 's3cret');
  });

  test('forwards the failure when login fails', () async {
    const failure = ServerFailure('Invalid credentials');
    final repo = FakeAuthRepo(const Left(failure));
    final useCase = LoginUseCase(repo);

    final result =
        await useCase(const LoginParams(email: 'gerges@example.com', password: 'wrong'));

    expect(result.isLeft(), isTrue);
    final left =
        result.fold((l) => l, (r) => throw StateError('expected Left'));
    expect(left.message, 'Invalid credentials');
    expect(left, isA<ServerFailure>());
  });
}