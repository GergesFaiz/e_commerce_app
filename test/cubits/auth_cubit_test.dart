import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/profile_usecases.dart';
import 'package:e_commerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:e_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_commerce/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_auth_repo.dart';

void main() {
  const user = UserEntity(
    name: 'Gerges Faiz',
    email: 'gerges@example.com',
    token: 'jwt-token',
    id: 'u1',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  AuthCubit buildCubit(Either<Failure, UserEntity> loginResult) {
    final repo = FakeAuthRepo(loginResult);
    return AuthCubit(
      LoginUseCase(repo),
      RegisterUseCase(repo),
      ForgotPasswordUseCase(repo),
      VerifyResetCodeUseCase(repo),
      ResetPasswordUseCase(repo),
      ChangePasswordUseCase(repo),
      UpdateProfileUseCase(repo),
      VerifyTokenUseCase(repo),
    );
  }

  group('login', () {
    test('emits AuthFailure when fields are empty', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.login('', '');

      expect(cubit.state, isA<AuthFailure>());
      expect((cubit.state as AuthFailure).message, 'Please fill in all fields');
    });

    test('emits loading then success and persists the token', () async {
      final cubit = buildCubit(const Right(user));
      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthSuccess>()]),
      );

      await cubit.login('gerges@example.com', '123456');
      await expected;

      expect((cubit.state as AuthSuccess).user.token, 'jwt-token');
      expect(CacheHelper.getToken(), 'jwt-token');
    });

    test('emits loading then failure with the server message', () async {
      const failure = ServerFailure('Invalid credentials');
      final cubit = buildCubit(const Left(failure));
      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthFailure>()]),
      );

      await cubit.login('gerges@example.com', 'wrongpass');
      await expected;

      expect((cubit.state as AuthFailure).message, 'Invalid credentials');
    });
  });

  group('register', () {
    test('emits AuthFailure when any field is empty', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.register(
        name: '',
        email: 'gerges@example.com',
        password: '123456',
        phone: '',
      );

      expect(cubit.state, isA<AuthFailure>());
      expect((cubit.state as AuthFailure).message, 'All fields are required');
    });
  });

  group('forgotPassword', () {
    test('emits AuthFailure for an invalid email', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.forgotPassword('not-an-email');

      expect(cubit.state, isA<AuthFailure>());
      expect(
        (cubit.state as AuthFailure).message,
        'Please enter a valid email address',
      );
    });

    test('resets to initial when the reset email is accepted', () async {
      final cubit = buildCubit(const Right(user));
      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthInitial>()]),
      );

      await cubit.forgotPassword('gerges@example.com');
      await expected;
    });
  });

  group('reset flow', () {
    test('verifyResetCode rejects an empty code', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.verifyResetCode('   ');

      expect(cubit.state, isA<AuthFailure>());
    });

    test('verifyResetCode emits message on success', () async {
      final cubit = buildCubit(const Right(user));
      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthMessage>()]),
      );

      await cubit.verifyResetCode('123456');
      await expected;
    });

    test('resetPassword rejects short passwords', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.resetPassword(email: 'a@b.com', newPassword: '123');

      expect(cubit.state, isA<AuthFailure>());
    });

    test('register persists token and user id', () async {
      final cubit = buildCubit(const Right(user));

      await cubit.register(
        name: 'Gerges',
        email: 'gerges@example.com',
        password: '123456',
        phone: '01000000000',
      );
      await pumpEventQueue();

      expect(CacheHelper.getToken(), 'jwt-token');
      expect(CacheHelper.getUserId(), 'u1');
    });
  });

  group('logout', () {    test('clears cached credentials and returns to AuthInitial', () async {
      await CacheHelper.saveToken('jwt-token');
      expect(CacheHelper.getToken(), 'jwt-token');

      final cubit = buildCubit(const Right(user));
      cubit.logout();
      await pumpEventQueue();

      expect(cubit.state, isA<AuthInitial>());
      expect(CacheHelper.getToken(), isNull);
    });
  });
}