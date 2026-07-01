import 'package:json_annotation/json_annotation.dart';

import 'torrents.dart';

part 'movies.g.dart';

@JsonSerializable()
class Movies {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "imdb_code")
  final String? imdbCode;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "title_english")
  final String? titleEnglish;
  @JsonKey(name: "title_long")
  final String? titleLong;
  @JsonKey(name: "slug")
  final String? slug;
  @JsonKey(name: "year")
  final int? year;
  @JsonKey(name: "rating")
  final double? rating;
  @JsonKey(name: "runtime")
  final int? runtime;
  @JsonKey(name: "genres")
  final List<String>? genres;
  @JsonKey(name: "summary")
  final String? summary;
  @JsonKey(name: "description_full")
  final String? descriptionFull;
  @JsonKey(name: "synopsis")
  final String? synopsis;
  @JsonKey(name: "yt_trailer_code")
  final String? ytTrailerCode;
  @JsonKey(name: "language")
  final String? language;
  @JsonKey(name: "mpa_rating")
  final String? mpaRating;
  @JsonKey(name: "background_image")
  final String? backgroundImage;
  @JsonKey(name: "background_image_original")
  final String? backgroundImageOriginal;
  @JsonKey(name: "small_cover_image")
  final String? smallCoverImage;
  @JsonKey(name: "medium_cover_image")
  final String? mediumCoverImage;
  @JsonKey(name: "large_cover_image")
  final String? largeCoverImage;
  @JsonKey(name: "state")
  final String? state;
  @JsonKey(name: "torrents")
  final List<Torrents>? torrents;
  @JsonKey(name: "date_uploaded")
  final String? dateUploaded;
  @JsonKey(name: "date_uploaded_unix")
  final int? dateUploadedUnix;
  @JsonKey(name: "like_count")
  final int? likeCount;
  @JsonKey(name: "download_count")
  final int? downloadCount;
  @JsonKey(name: "medium_screenshot_image1")
  final String? mediumScreenshotImage1;
  @JsonKey(name: "medium_screenshot_image2")
  final String? mediumScreenshotImage2;
  @JsonKey(name: "medium_screenshot_image3")
  final String? mediumScreenshotImage3;

  Movies({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.state,
    this.torrents,
    this.dateUploaded,
    this.dateUploadedUnix,
    this.likeCount,
    this.downloadCount,
    this.mediumScreenshotImage1,
    this.mediumScreenshotImage2,
    this.mediumScreenshotImage3,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return _$MoviesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MoviesToJson(this);
  }
}
