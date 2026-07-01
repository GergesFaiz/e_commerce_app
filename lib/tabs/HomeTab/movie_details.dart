import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/cast_item.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/details_container.dart';

import 'movie_card.dart';
import 'movie_details_state.dart';
import 'movie_details_view_model.dart';

class MovieDetails extends StatefulWidget {
  final Movies movie;
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late final MovieDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MovieDetailsViewModel();
    _viewModel.loadMovieData(widget.movie.id ?? 0);
    _viewModel.addToHistory(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.gray,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildTitleSection(context),
              SizedBox(height: 15.h),
              BlocBuilder<MovieDetailsViewModel, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoading ||
                      state is MovieDetailsInitial) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.h),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is MovieDetailsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                        ),
                      ),
                    );
                  }
                  if (state is MovieDetailsLoaded) {
                    return _buildMainDetails(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainDetails(BuildContext context, MovieDetailsLoaded state) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DetailsContainer(text: state.likeCount, icon: Icons.favorite),
              DetailsContainer(text: state.runtime.toString(),
                  icon: Icons.access_time_filled),
              DetailsContainer(text: state.rating.toString(), icon: Icons.star),
            ],
          ),

          // Screenshots
          if (state.screenshots.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text('Screenshots', style: AppStyles.bold22White),
            SizedBox(height: 12.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.screenshots.length,
              itemBuilder: (context, index) =>
                  _buildScreenshotItem(state.screenshots[index]),
            ),
          ],

          // Similar
          if (state.suggestions.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.similar, style: AppStyles.bold22White),
            SizedBox(height: 10.h),
            _buildSuggestionsGrid(state),
          ],

          // Summary
          SizedBox(height: 20.h),
          Text(loc.summary, style: AppStyles.bold22White),
          SizedBox(height: 8.h),
          Text(
            widget.movie.synopsis ?? widget.movie.descriptionFull ??
                'No description available.',
            style: AppStyles.medium16white,
          ),

          // Cast
          if (state.cast.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.cast, style: AppStyles.bold22White),
            SizedBox(height: 8.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.cast.length,
              itemBuilder: (context, index) {
                final actor = state.cast[index];
                return CastItem(
                  imageUrl: actor['url_small_image'] ?? '',
                  actorName: actor['name'] ?? '',
                  characterName: actor['character_name'] ?? '',
                );
              },
            ),
          ],

          // Genres
          if (state.genres.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.genres, style: AppStyles.bold22White),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: state.genres
                  .map((genre) =>
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ))
                  .toList(),
            ),
          ],

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.movie.backgroundImageOriginal ?? '',
          width: double.infinity,
          height: 0.60.sh,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
              Container(height: 300.h, color: Colors.grey[900]),
        ),
        Container(
          height: 0.60.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.gray],
            ),
          ),
        ),
        Positioned.fill(
          top: 0.2.sh,
          child: Center(
            child: InkWell(
              onTap: () {},
              child: Image.asset('assets/images/Group 21.png'),
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              StreamBuilder<bool>(
                stream: _viewModel.isMovieInWatchlist(widget.movie.id ?? 0),
                builder: (context, snapshot) {
                  final isSaved = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      Icons.bookmark_rounded,
                      color: isSaved ? Colors.amber : AppColors.white,
                    ),
                    onPressed: () => _viewModel.toggleWatchlist(widget.movie),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          Text(widget.movie.title ?? '', style: AppStyles.bold18White, textAlign: TextAlign.center),
          SizedBox(height: 10.h),
          Text(widget.movie.year?.toString() ?? '', style: AppStyles.bold16White, textAlign: TextAlign.center),
          SizedBox(height: 10.h),
          CustomElevatedButton(
            label: AppLocalizations.of(context)!.watch,
            backgroundColor: AppColors.red,
            textStyle: AppStyles.bold20White,
            onPressed: () => _viewModel.addToHistory(widget.movie),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotItem(String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 0.25.sh,
          errorWidget: (_, __, ___) =>
              Container(
                height: 150.h,
            color: Colors.grey[900],
            child: const Center(child: Icon(Icons.error, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsGrid(MovieDetailsLoaded state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.suggestions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        final movie = state.suggestions[index];
        return MovieCard(
          imageUrl: movie.mediumCoverImage ?? '',
          rating: movie.rating.toString(),
        );
      },
    );
  }
}
