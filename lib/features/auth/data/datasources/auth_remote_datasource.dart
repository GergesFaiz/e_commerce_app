import 'package:e_commerce/core/network/api_service.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import 'package:e_commerce/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({required String name, required String email, required String password, required String phone});
  Future<String> forgotPassword(String email);
  Future<String> verifyResetCode(String code);
  Future<String> resetPassword({required String email, required String newPassword});
  Future<String> changeMyPassword({required String current, required String password});
  Future<String> updateMe({required String name, required String email, required String phone});
  Future<bool> verifyToken(String token);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiService _api;
  AuthRemoteDatasourceImpl(this._api);

  @override
  Future<UserModel> login({required String email, required String password}) =>
      _api.login({'email': email, 'password': password});

  @override
  Future<UserModel> register({required String name, required String email, required String password, required String phone}) =>
      _api.register({'name': name, 'email': email, 'password': password, 'rePassword': password, 'phone': phone});

  @override
  Future<String> forgotPassword(String email) async {
    final res = await _api.forgotPassword({'email': email});
    return res.data?['message'] ?? '';
  }

  @override
  Future<String> verifyResetCode(String code) async {
    final res = await _api.verifyResetCode({'resetCode': code});
    final data = res.data;
    if (data is Map && data['status'] != null) return data['status'].toString();
    return 'Code verified';
  }

  @override
  Future<String> resetPassword({required String email, required String newPassword}) async {
    final res = await _api.resetPassword({'email': email, 'newPassword': newPassword});
    return _messageOf(res.data, 'Password reset successfully');
  }

  @override
  Future<String> changeMyPassword({required String current, required String password}) async {
    final token = CacheHelper.getToken() ?? '';
    final res = await _api.updatePassword(
      {'currentPassword': current, 'password': password, 'rePassword': password},
      token,
    );
    return _messageOf(res.data, 'Password updated');
  }

  @override
  Future<String> updateMe({required String name, required String email, required String phone}) async {
    final token = CacheHelper.getToken() ?? '';
    final res = await _api.updateMe(
      {'name': name, 'email': email, 'phone': phone},
      token,
    );
    return _messageOf(res.data, 'Profile updated');
  }

  @override
  Future<bool> verifyToken(String token) async {
    await _api.verifyToken(token);
    return true;
  }

  String _messageOf(dynamic data, String fallback) {
    if (data is Map && data['message'] is String) return data['message'] as String;
    return fallback;
  }
}