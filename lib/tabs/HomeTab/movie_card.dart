import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final String rating;
  final String? title;
  final VoidCallback? onTap;
  final int? movieId;

  /// When true, uses ScreenUtil sizing (MovieCard2 style).
  /// When false, uses StackFit.expand sizing (MovieCard / MovieCard1 style).
  final bool useContextSize;

  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.rating,
    this.title,
    this.onTap,
    this.movieId,
    this.useContextSize = false,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = useContextSize ? 12.r : 20.r;

    final Widget image = useContextSize
        ? ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 0.44.sw,
        height: 0.28.sh,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            Container(
              color: Colors.grey[850],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (_, __, ___) =>
            Container(
              color: Colors.grey[850],
              child: const Icon(Icons.broken_image, color: Colors.white54),
            ),
      ),
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            Container(
              color: Colors.grey[850],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (_, __, ___) =>
            Container(
              color: Colors.grey[850],
              child: const Icon(Icons.broken_image, color: Colors.white54),
            ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: useContextSize
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: useContextSize ? StackFit.loose : StackFit.expand,
          children: [
            // Image
            image,

            // Gradient overlay (only in expand mode)
            if (!useContextSize)
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

            // Rating badge
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(useContextSize ? 0.6 : 0.75),
                  borderRadius: BorderRadius.circular(
                      useContextSize ? 8.r : 12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: useContextSize ? 4.w : 0,
                  children: [
                    if (!useContextSize) ...[
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(rating, style: AppStyles.regular16white),
                    ] else
                      ...[
                        Text(
                          rating,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.star, color: AppColors.amber, size: 14.sp),
                      ],
                  ],
                ),
              ),
            ),

            // Title (optional)
            if (title != null && !useContextSize)
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Text(
                  title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bold16White.copyWith(fontSize: 14.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}