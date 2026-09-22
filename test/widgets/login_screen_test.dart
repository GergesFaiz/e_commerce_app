import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'package:e_commerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:e_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_commerce/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

  Future<AuthCubit> pumpLoginScreen(
    WidgetTester tester,
    FakeAuthRepo repo,
  ) async {
    final cubit = AuthCubit(
      LoginUseCase(repo),
      RegisterUseCase(repo),
      ForgotPasswordUseCase(repo),
    );

    final router = GoRouter(
      initialLocation: AppRouter.login,
      routes: [
        GoRoute(
          path: AppRouter.login,
          builder: (_, __) =>
              BlocProvider.value(value: cubit, child: const LoginScreen()),
        ),
        GoRoute(
          path: AppRouter.home,
          builder: (_, __) => const Scaffold(body: Text('HOME')),
        ),
        GoRoute(
          path: AppRouter.register,
          builder: (_, __) => const Scaffold(body: Text('REGISTER')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    return cubit;
  }

  group('LoginScreen', () {
    testWidgets('renders the form fields and login button', (tester) async {
      await pumpLoginScreen(tester, FakeAuthRepo(const Right(user)));

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('shows validation errors and does not call the repository',
        (tester) async {
      final repo = FakeAuthRepo(const Right(user));
      await pumpLoginScreen(tester, repo);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(repo.loginCalls, 0);
    });

    testWidgets('shows a loading indicator while the request is in flight',
        (tester) async {
      final gate = Completer<Either<Failure, UserEntity>>();
      final repo = FakeAuthRepo(const Right(user), loginGate: gate);
      await pumpLoginScreen(tester, repo);

      await tester.enterText(find.byType(TextFormField).at(0), 'gerges@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      gate.complete(const Right(user));
      await tester.pumpAndSettle();
    });

    testWidgets('navigates to home after a successful login', (tester) async {
      final repo = FakeAuthRepo(const Right(user));
      await pumpLoginScreen(tester, repo);

      await tester.enterText(find.byType(TextFormField).at(0), 'gerges@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      expect(repo.loginCalls, 1);
      expect(repo.lastEmail, 'gerges@example.com');
    });
  });
}