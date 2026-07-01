import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/i_products_repo.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepoImpl implements IProductsRepo {
  final ProductsRemoteDatasource _remote;
  final NetworkInfo _network;
  ProductsRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({String? categoryId}) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final res = await _remote.getProducts();
      var items = res.data.map((e) => e.toEntity()).toList();
      if (categoryId != null) {
        items = items.where((p) => p.categoryName.isNotEmpty).toList();
      }
      return Right(items);
    } on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final res = await _remote.getProductById(id);
      return Right(res.data.toEntity());
    } on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }
}