import 'package:e_commerce/core/network/api_service.dart';
import 'package:e_commerce/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({required String name, required String email, required String password, required String phone});
  Future<String> forgotPassword(String email);
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
}