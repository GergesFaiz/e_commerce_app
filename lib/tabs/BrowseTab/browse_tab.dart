import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/tabs/BrowseTab/browse_state.dart';
import 'package:movies/tabs/BrowseTab/browse_tab_view_model.dart';
import 'package:movies/tabs/HomeTab/movie_details.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

import '../HomeTab/movie_card.dart';


class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BrowseTabViewModel(),
      child: BlocBuilder<BrowseTabViewModel, BrowseState>(
        builder: (context, state) {
          final viewModel = context.read<BrowseTabViewModel>();

          // Load movies only once when first built
          if (state is BrowseInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadMovies();
            });
          }

          if (state is BrowseLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.amber),
            );
          }

          if (state is BrowseError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SafeArea(
              child: Column(
                children: [
                  // Categories
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SizedBox(
                      height: 52.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: viewModel.allGenres.length,
                        itemBuilder: (context, index) {
                          final genre = viewModel.allGenres[index];
                          final isSelected = viewModel.selectedGenre == genre;

                          return GestureDetector(
                            onTap: () => viewModel.selectGenre(genre),
                            child: Container(
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.amber : AppColors
                                    .gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                genre,
                                style: AppStyles.bold16White.copyWith(
                                  color: isSelected ? Colors.black : AppColors
                                      .white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Movies Grid
                  Expanded(
                    child: viewModel.filteredMovies.isEmpty
                        ? const Center(
                      child: Text(
                        "No movies found",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                        : GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 18.h,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: viewModel.filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = viewModel.filteredMovies[index];
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
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}