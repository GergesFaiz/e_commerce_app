import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final Color gradientColor;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.gradientColor,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: AppAssets.onbaordingImage1,
    title: "Find Your Next\nFavorite Movie Here",
    description:
        "Get access to a huge library of movies\nto suit all tastes. You will surely like it.",
    buttonText: "Explore Now",
    gradientColor: AppColors.blackColor,
  ),
  OnboardingData(
    image: AppAssets.onbaordingImage2,
    title: "Discover Movies",
    description:
        "Explore a vast collection of movies in all\nqualities and genres. Find your next\nfavorite film with ease.",
    buttonText: "Next",
    gradientColor: Color(0XFF084250),
  ),
  OnboardingData(
    image: AppAssets.onbaordingImage3,
    title: "Explore All Genres",
    description:
        "Discover movies from every genre, in all\navailable qualities. Find something new\nand exciting to watch every day.",
    buttonText: "Next",
    gradientColor: Color(0XFF85210E),
  ),
  OnboardingData(
    image: AppAssets.onbaordingImage4,
    title: "Create Watchlists",
    description:
        "Save movies to your watchlist to keep\ntrack of what you want to watch next.\nEnjoy films in various qualities and\ngenres.",
    buttonText: "Next",
    gradientColor: Color(0XFF4C2471),
  ),
  OnboardingData(
    image: AppAssets.onbaordingImage5,
    title: "Rate, Review, and Learn",
    description:
        "Share your thoughts on the movies\nyou've watched. Dive deep into film\ndetails and help others discover great\nmovies with your reviews.",
    buttonText: "Next",
    gradientColor: Color(0XFF601321),
  ),
  OnboardingData(
    image: AppAssets.onbaordingImage6,
    title: "Start Watching Now",
    description: "",
    buttonText: "Finish",
    gradientColor: Color(0XFF2A2C30),
  ),
];
