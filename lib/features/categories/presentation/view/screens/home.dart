import 'package:e_commerce/core/di/di.dart';
import 'package:e_commerce/features/categories/domain/entities/category_entity.dart';
import 'package:e_commerce/features/categories/domain/usecase/get_category_usecase.dart';
import 'package:e_commerce/features/categories/presentation/view_model/cubit.dart';
import 'package:e_commerce/features/categories/presentation/view_model/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  HomeViewModel viewModel = getIt.get<HomeViewModel>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeViewModel>(
      create: (context) => viewModel,
      child: Scaffold(
        body: Center(child:
            BlocBuilder<HomeViewModel, HomeStates>(builder: (context, state) {
          // switch (state) {
          //   case HomeLoadingState():
          //   case HomeInitialState():
          //     return const CircularProgressIndicator();
          //   case HomeErrorState():
          //     return Text(state.error);
          //   case HomeSuccessState():
          //     return CatListWidget(catList: state.categories);
          // }

          if (state.error != null) return Text(state.error!);

          return Column(
            children: [
              const SizedBox(height: 100),
              CatListWidget(
                list: state.catList,
                isLoading: state.isCatLoading,
              ),
              CatListWidget(
                list: state.productList,
                isLoading: state.isProductLoading,
              ),
            ],
          );
        })),
      ),
    );
  }
}

class CatListWidget extends StatelessWidget {
  const CatListWidget({
    super.key,
    required this.list,
    this.isLoading = true,
  });

  final List<CategoryEntity> list;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: const CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            width: MediaQuery.of(context).size.width * .9,
            height: 50,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    list[index].name ?? "No Name",
                  ),
                );
              },
            ),
          );
  }
}
