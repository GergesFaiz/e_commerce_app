import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final ForgotPasswordUseCase _forgot;
  AuthCubit(this._login, this._register, this._forgot) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _login(LoginParams(email: email, password: password));
    result.fold(
      (f) => emit(AuthFailure(f.message)),
      (user) {
        CacheHelper.saveToken(user.token);
        CacheHelper.saveUserId(user.id);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> register({required String name, required String email, required String password, required String phone}) async {
    emit(AuthLoading());
    final result = await _register(RegisterParams(name: name, email: email, password: password, phone: phone));
    result.fold((f) => emit(AuthFailure(f.message)), (user) => emit(AuthSuccess(user)));
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await _forgot(email);
    result.fold((f) => emit(AuthFailure(f.message)), (_) => emit(AuthInitial()));
  }
}