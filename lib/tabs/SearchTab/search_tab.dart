import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/tabs/HomeTab/movie_details.dart';
import 'package:movies/tabs/SearchTab/search_state.dart';
import 'package:movies/tabs/SearchTab/search_tab_view_model.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

import '../HomeTab/movie_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchTabViewModel(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: BlocBuilder<SearchTabViewModel, SearchState>(
                    builder: (context, state) {
                      final viewModel = context.read<SearchTabViewModel>();

                      return TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        cursorColor: AppColors.white,
                        style: AppStyles.bold18White,
                        decoration: InputDecoration(
                          hintText: "Search movies...",
                          hintStyle: AppStyles.bold18White.copyWith(
                            color: AppColors.lightGreyColor,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: SvgPicture.asset(
                              AppAssets.search,
                              width: 24.w,
                              height: 24.w,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.gray.withOpacity(0.6),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          viewModel.updateSearchText(value);
                        },
                      );
                    },
                  ),
                ),

                // Results
                Expanded(
                  child: BlocBuilder<SearchTabViewModel, SearchState>(
                    builder: (context, state) {
                      final viewModel = context.read<SearchTabViewModel>();

                      if (viewModel.searchText.isEmpty) {
                        return Center(
                          child: Image.asset(AppAssets.empty1, width: 240.w),
                        );
                      }

                      if (state is SearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.amber,
                          ),
                        );
                      }

                      if (state is SearchError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      if (state is SearchEmpty ||
                          (state is SearchLoaded && state.movies.isEmpty)) {
                        return Center(
                          child: Text(
                            "No movies found",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      }

                      if (state is SearchLoaded) {
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: 0.68,
                              ),
                          itemCount: state.movies.length,
                          itemBuilder: (context, index) {
                            final movie = state.movies[index];
                            return MovieCard(
                              imageUrl: movie.mediumCoverImage ?? '',
                              rating: (movie.rating ?? 0).toStringAsFixed(1),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MovieDetails(movie: movie),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
