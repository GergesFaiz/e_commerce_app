import 'dart:convert';

import 'torrent.details.dart';

class Moviesdetails {
  int? id;
  String? url;
  String? imdbCode;
  String? title;
  String? titleEnglish;
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<String>? genres;
  String? summary;
  String? descriptionFull;
  String? synopsis;
  String? ytTrailerCode;
  String? language;
  String? mpaRating;
  String? backgroundImage;
  String? backgroundImageOriginal;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  String? state;

  String? mediumScreenshotImage1;
  String? mediumScreenshotImage2;
  String? mediumScreenshotImage3;
  String? largeScreenshotImage1;
  String? largeScreenshotImage2;
  String? largeScreenshotImage3;

  int? downloadCount;
  int? likeCount;
  String? dateUploaded;
  int? dateUploadedUnix;

  List<Torrent>? torrents;
  List<Cast>? cast;

  Moviesdetails({
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
    this.mediumScreenshotImage1,
    this.mediumScreenshotImage2,
    this.mediumScreenshotImage3,
    this.largeScreenshotImage1,
    this.largeScreenshotImage2,
    this.largeScreenshotImage3,
    this.state,
    this.downloadCount,
    this.likeCount,
    this.dateUploaded,
    this.dateUploadedUnix,
    this.torrents,
    this.cast,
  });

  factory Moviesdetails.fromMap(Map<String, dynamic> data) {
    return Moviesdetails(
      id: data['id'] as int?,
      url: data['url'] as String?,
      imdbCode: data['imdb_code'] as String?,
      title: data['title'] as String?,
      titleEnglish: data['title_english'] as String?,
      titleLong: data['title_long'] as String?,
      slug: data['slug'] as String?,
      year: data['year'] as int?,
      rating: (data['rating'] as num?)?.toDouble(),
      runtime: data['runtime'] as int?,
      genres: (data['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      summary: data['summary'] as String?,
      descriptionFull: data['description_full'] as String?,
      synopsis: data['synopsis'] as String?,
      ytTrailerCode: data['yt_trailer_code'] as String?,
      language: data['language'] as String?,
      mpaRating: data['mpa_rating'] as String?,
      backgroundImage: data['background_image'] as String?,
      backgroundImageOriginal: data['background_image_original'] as String?,
      smallCoverImage: data['small_cover_image'] as String?,
      mediumCoverImage: data['medium_cover_image'] as String?,
      largeCoverImage: data['large_cover_image'] as String?,
      mediumScreenshotImage1: data['medium_screenshot_image1'] as String?,
      mediumScreenshotImage2: data['medium_screenshot_image2'] as String?,
      mediumScreenshotImage3: data['medium_screenshot_image3'] as String?,
      largeScreenshotImage1: data['large_screenshot_image1'] as String?,
      largeScreenshotImage2: data['large_screenshot_image2'] as String?,
      largeScreenshotImage3: data['large_screenshot_image3'] as String?,
      state: data['state'] as String?,
      downloadCount: data['download_count'] as int?,
      likeCount: data['like_count'] as int?,
      dateUploaded: data['date_uploaded'] as String?,
      dateUploadedUnix: data['date_uploaded_unix'] as int?,
      torrents: data['torrents'] == null
          ? null
          : (data['torrents'] as List)
              .map((t) => Torrent.fromMap(t as Map<String, dynamic>))
              .toList(),
      cast: data['cast'] == null
          ? null
          : (data['cast'] as List)
              .map((c) => Cast.fromMap(c as Map<String, dynamic>))
                .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'imdb_code': imdbCode,
      'title': title,
      'title_english': titleEnglish,
      'title_long': titleLong,
      'slug': slug,
      'year': year,
      'rating': rating,
      'runtime': runtime,
      'genres': genres,
      'summary': summary,
      'description_full': descriptionFull,
      'synopsis': synopsis,
      'yt_trailer_code': ytTrailerCode,
      'language': language,
      'mpa_rating': mpaRating,
      'background_image': backgroundImage,
      'background_image_original': backgroundImageOriginal,
      'small_cover_image': smallCoverImage,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
      'medium_screenshot_image1': mediumScreenshotImage1,
      'medium_screenshot_image2': mediumScreenshotImage2,
      'medium_screenshot_image3': mediumScreenshotImage3,
      'large_screenshot_image1': largeScreenshotImage1,
      'large_screenshot_image2': largeScreenshotImage2,
      'large_screenshot_image3': largeScreenshotImage3,
      'state': state,
      'download_count': downloadCount,
      'like_count': likeCount,
      'date_uploaded': dateUploaded,
      'date_uploaded_unix': dateUploadedUnix,
      'torrents': torrents?.map((t) => t.toMap()).toList(),
      'cast': cast?.map((c) => c.toMap()).toList(),
    };
  }

  factory Moviesdetails.fromJson(String data) {
    return Moviesdetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}

class Cast {
  String? name;
  String? characterName;
  String? urlSmallImage;

  Cast({this.name, this.characterName, this.urlSmallImage});

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      name: map['name'] as String?,
      characterName: map['character_name'] as String?,
      urlSmallImage: map['url_small_image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': urlSmallImage,
    };
  }
}