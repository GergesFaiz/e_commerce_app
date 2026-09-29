import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/core/utils/jwt_helper.dart';
import 'package:e_commerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:e_commerce/features/auth/domain/usecases/profile_usecases.dart';
import 'package:e_commerce/features/auth/domain/entities/user_entity.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyResetCodeUseCase _verifyResetCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final VerifyTokenUseCase _verifyTokenUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._forgotPasswordUseCase,
    this._verifyResetCodeUseCase,
    this._resetPasswordUseCase,
    this._changePasswordUseCase,
    this._updateProfileUseCase,
    this._verifyTokenUseCase,
  ) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("Please fill in all fields"));
      return;
    }

    emit(AuthLoading());
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        await _saveSession(user);
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

    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (user) async {
        await _saveSession(user, phone: phone);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _saveSession(UserEntity user, {String? phone}) async {
    await CacheHelper.saveToken(user.token);
    final id = JwtHelper.userId(user.token);
    await CacheHelper.saveUserId(id.isNotEmpty ? id : user.id);
    await CacheHelper.saveProfile(name: user.name, email: user.email, phone: phone);
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

  Future<void> verifyResetCode(String code) async {
    if (code.trim().isEmpty) {
      emit(AuthFailure('Please enter the reset code'));
      return;
    }
    emit(AuthLoading());
    final result = await _verifyResetCodeUseCase(code.trim());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (msg) => emit(AuthMessage(msg)),
    );
  }

  Future<void> resetPassword({required String email, required String newPassword}) async {
    if (newPassword.length < 6) {
      emit(AuthFailure('Password must be at least 6 characters'));
      return;
    }
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(email: email, newPassword: newPassword),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (msg) => emit(AuthMessage(msg)),
    );
  }

  Future<void> changePassword({required String current, required String password}) async {
    if (password.length < 6) {
      emit(AuthFailure('Password must be at least 6 characters'));
      return;
    }
    emit(AuthLoading());
    final result = await _changePasswordUseCase(
      ChangePasswordParams(current: current, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (msg) => emit(AuthMessage(msg)),
    );
  }

  Future<void> updateProfile({required String name, required String email, required String phone}) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      emit(AuthFailure('All fields are required'));
      return;
    }
    emit(AuthLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(name: name, email: email, phone: phone),
    );
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (msg) async {
        await CacheHelper.saveProfile(name: name, email: email, phone: phone);
        emit(AuthMessage(msg));
      },
    );
  }

  /// Returns true when the cached token is still valid.
  Future<bool> isSessionValid() async {
    final token = CacheHelper.getToken();
    if (token == null || token.isEmpty) return false;
    final result = await _verifyTokenUseCase(token);
    return result.fold((_) => false, (ok) => ok);
  }

  Future<void> logout() async {
    await CacheHelper.clearSession();
    emit(AuthInitial());
  }
}
