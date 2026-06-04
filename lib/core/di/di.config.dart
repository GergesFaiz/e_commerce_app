// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/categories/data/datasource/contract/datasource_contract.dart'
    as _i596;
import '../../features/categories/data/datasource/remote/remote_datasource_impl.dart'
    as _i1034;
import '../../features/categories/data/repo/category_repo_impl.dart' as _i782;
import '../../features/categories/domain/repo/category_repo_contract.dart'
    as _i450;
import '../../features/categories/domain/usecase/get_category_usecase.dart'
    as _i526;
import '../../features/categories/presentation/view_model/cubit.dart' as _i138;
import '../../features/products/domain/usecases/get_products_usecase.dart'
    as _i15;
import '../api_manager/api_manager.dart' as _i266;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i15.GetProductsUseCase>(() => _i15.GetProductsUseCase());
    gh.singleton<_i266.ApiManager>(() => _i266.ApiManager());
    gh.singleton<_i596.DataSourceContract>(
        () => _i1034.RemoteDataSourceImpl(gh<_i266.ApiManager>()));
    gh.factory<_i450.CategoryRepoContract>(
        () => _i782.CategoryRepoImpl(gh<_i596.DataSourceContract>()));
    gh.factory<_i526.GetCategoriesUseCase>(() => _i526.GetCategoriesUseCase(
        categoryRepo: gh<_i450.CategoryRepoContract>()));
    gh.factory<_i138.HomeViewModel>(() => _i138.HomeViewModel(
          gh<_i526.GetCategoriesUseCase>(),
          gh<_i15.GetProductsUseCase>(),
        ));
    return this;
  }
}
