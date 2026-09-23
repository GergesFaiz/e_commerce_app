import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/di/base_usecase.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/network/network_info.dart';
import '../data/datasources/addresses_remote_datasource.dart';
import '../data/models/address_model.dart';

abstract class IAddressesRepo {
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, String>> addAddress(Address address);
  Future<Either<Failure, void>> deleteAddress(String id);
}

class AddressesRepoImpl implements IAddressesRepo {
  final AddressesRemoteDatasource _remote;
  final NetworkInfo _network;
  AddressesRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getAddresses());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, String>> addAddress(Address address) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.addAddress(address));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      await _remote.deleteAddress(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }
}

class GetAddressesUseCase extends BaseUseCase<List<Address>, NoParams> {
  final IAddressesRepo _repo;
  GetAddressesUseCase(this._repo);
  @override
  Future<Either<Failure, List<Address>>> call(NoParams p) => _repo.getAddresses();
}

class AddAddressUseCase extends BaseUseCase<String, Address> {
  final IAddressesRepo _repo;
  AddAddressUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(Address a) => _repo.addAddress(a);
}

class DeleteAddressUseCase extends BaseUseCase<void, String> {
  final IAddressesRepo _repo;
  DeleteAddressUseCase(this._repo);
  @override
  Future<Either<Failure, void>> call(String id) => _repo.deleteAddress(id);
}
