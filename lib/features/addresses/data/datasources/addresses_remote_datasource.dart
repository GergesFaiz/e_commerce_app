import 'package:e_commerce/core/network/api_service.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import '../models/address_model.dart';

abstract class AddressesRemoteDatasource {
  Future<List<Address>> getAddresses();
  Future<String> addAddress(Address address);
  Future<void> deleteAddress(String id);
}

class AddressesRemoteDatasourceImpl implements AddressesRemoteDatasource {
  final ApiService _api;
  AddressesRemoteDatasourceImpl(this._api);

  @override
  Future<List<Address>> getAddresses() async {
    final token = CacheHelper.getToken() ?? '';
    final res = await _api.getAddresses(token);
    return Address.listOf(res.data);
  }

  @override
  Future<String> addAddress(Address address) async {
    final token = CacheHelper.getToken() ?? '';
    final res = await _api.addAddress(address.toJson(), token);
    final data = res.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    return 'Address added';
  }

  @override
  Future<void> deleteAddress(String id) async {
    final token = CacheHelper.getToken() ?? '';
    await _api.deleteAddress(id, token);
  }
}
