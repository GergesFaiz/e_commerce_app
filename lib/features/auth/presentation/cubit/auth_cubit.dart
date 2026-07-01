import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._forgotPasswordUseCase,
  ) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("Please fill in all fields"));
      return;
    }

    emit(AuthLoading());
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) async {
        await CacheHelper.saveToken(user.token);
        await CacheHelper.saveUserId(user.id);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      emit(AuthFailure("All fields are required"));
      return;
    }

    emit(AuthLoading());
    final result = await _registerUseCase(RegisterParams(
      name: name,
      email: email,
      password: password,
      phone: phone,
    ));

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      emit(AuthFailure("Please enter a valid email address"));
      return;
    }

    emit(AuthLoading());
    final result = await _forgotPasswordUseCase(email);
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  void logout() async {
    await CacheHelper.removeToken();
    await CacheHelper.removeUserId();
    emit(AuthInitial());
  }
}
