import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/i_products_repo.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/products_response_model.dart';

class ProductsRepoImpl implements IProductsRepo {
  final ProductsRemoteDatasource _remote;
  final NetworkInfo _network;
  ProductsRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({String? categoryId}) async {
    if (!await _network.isConnected) {
      final cached = _readCache();
      if (cached != null) {
        return Right(_filterByCategory(cached, categoryId));
      }
      return const Left(NetworkFailure());
    }
    try {
      final res = await _remote.getProducts();
      _writeCache(res);
      final items = _filterByCategory(
        res.data.map((e) => e.toEntity()).toList(),
        categoryId,
      );
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

  List<ProductEntity> _filterByCategory(
    List<ProductEntity> items,
    String? categoryId,
  ) {
    if (categoryId == null) return items;
    return items.where((p) => p.categoryName.isNotEmpty).toList();
  }

  void _writeCache(ProductsResponseModel res) {
    try {
      CacheHelper.saveString(
        AppConstants.cachedProductsKey,
        jsonEncode(res.toJson()),
      );
    } catch (_) {
      // Cache is best-effort only.
    }
  }

  List<ProductEntity>? _readCache() {
    try {
      final raw = CacheHelper.getString(AppConstants.cachedProductsKey);
      if (raw == null || raw.isEmpty) return null;
      final res = ProductsResponseModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return res.data.map((e) => e.toEntity()).toList();
    } catch (_) {
      return null;
    }
  }
}