import 'package:json_annotation/json_annotation.dart';

part 'torrents.g.dart';

@JsonSerializable()
class Torrents {
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "hash")
  final String? hash;
  @JsonKey(name: "quality")
  final String? quality;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "is_repack")
  final String? isRepack;
  @JsonKey(name: "video_codec")
  final String? videoCodec;
  @JsonKey(name: "bit_depth")
  final String? bitDepth;
  @JsonKey(name: "audio_channels")
  final String? audioChannels;
  @JsonKey(name: "seeds")
  final int? seeds;
  @JsonKey(name: "peers")
  final int? peers;
  @JsonKey(name: "size")
  final String? size;
  @JsonKey(name: "size_bytes")
  final int? sizeBytes;
  @JsonKey(name: "date_uploaded")
  final String? dateUploaded;
  @JsonKey(name: "date_uploaded_unix")
  final int? dateUploadedUnix;

  Torrents({
    this.url,
    this.hash,
    this.quality,
    this.type,
    this.isRepack,
    this.videoCodec,
    this.bitDepth,
    this.audioChannels,
    this.seeds,
    this.peers,
    this.size,
    this.sizeBytes,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  factory Torrents.fromJson(Map<String, dynamic> json) {
    return _$TorrentsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TorrentsToJson(this);
  }
}