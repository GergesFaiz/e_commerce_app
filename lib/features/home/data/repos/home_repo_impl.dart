import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repos/i_home_repo.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepoImpl implements IHomeRepo {
  final HomeRemoteDatasource _remote;
  final NetworkInfo _network;
  HomeRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final res = await _remote.getCategories();
      return Right(res.data.map((e) => e.toEntity()).toList());
    } on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final res = await _remote.getBrands();
      return Right(res.data.map((e) => e.toEntity()).toList());
    } on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }
}