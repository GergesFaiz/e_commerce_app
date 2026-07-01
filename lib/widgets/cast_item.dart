import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

class CastItem extends StatelessWidget {
  final String? imageUrl;
  final String? actorName;
  final String? characterName;

  const CastItem({
    super.key,
    required this.imageUrl,
    required this.actorName,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[800],
                child: Icon(Icons.person, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 "Name: ${actorName??'Unknown Actor'} ",
                  style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                "Character: ${characterName ?? 'Unknown Character'}",
                   style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}