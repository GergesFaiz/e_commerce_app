import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../../domain/repos/i_wishlist_repo.dart';
import '../datasources/wishlist_remote_datasource.dart';

class WishlistRepoImpl implements IWishlistRepo {
  final WishlistRemoteDatasource _remote;
  final NetworkInfo _network;
  WishlistRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try { final r = await _remote.getWishlist(); return Right(r.data?.map((e) => e.toEntity()).toList() ?? []); }
    on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }

  @override
  Future<Either<Failure, String>> addToWishlist(String productId) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try { final r = await _remote.addToWishlist(productId); return Right(r.message); }
    on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }

  @override
  Future<Either<Failure, String>> removeFromWishlist(String productId) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try { final r = await _remote.removeFromWishlist(productId); return Right(r.message); }
    on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }
}