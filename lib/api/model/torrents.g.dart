// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torrents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Torrents _$TorrentsFromJson(Map<String, dynamic> json) => Torrents(
      url: json['url'] as String?,
      hash: json['hash'] as String?,
      quality: json['quality'] as String?,
      type: json['type'] as String?,
      isRepack: json['is_repack'] as String?,
      videoCodec: json['video_codec'] as String?,
      bitDepth: json['bit_depth'] as String?,
      audioChannels: json['audio_channels'] as String?,
      seeds: (json['seeds'] as num?)?.toInt(),
      peers: (json['peers'] as num?)?.toInt(),
      size: json['size'] as String?,
      sizeBytes: (json['size_bytes'] as num?)?.toInt(),
      dateUploaded: json['date_uploaded'] as String?,
      dateUploadedUnix: (json['date_uploaded_unix'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TorrentsToJson(Torrents instance) => <String, dynamic>{
      'url': instance.url,
      'hash': instance.hash,
      'quality': instance.quality,
      'type': instance.type,
      'is_repack': instance.isRepack,
      'video_codec': instance.videoCodec,
      'bit_depth': instance.bitDepth,
      'audio_channels': instance.audioChannels,
      'seeds': instance.seeds,
      'peers': instance.peers,
      'size': instance.size,
      'size_bytes': instance.sizeBytes,
      'date_uploaded': instance.dateUploaded,
      'date_uploaded_unix': instance.dateUploadedUnix,
    };
