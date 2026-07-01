import 'dart:convert';

class Torrent {
  String? url;
  String? hash;
  String? quality;
  String? type;
  String? isRepack;
  String? videoCodec;
  String? bitDepth;
  String? audioChannels;
  int? seeds;
  int? peers;
  String? size;
  int? sizeBytes;
  String? dateUploaded;
  int? dateUploadedUnix;

  Torrent({
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

  @override
  String toString() {
    return 'Torrent(url: $url, hash: $hash, quality: $quality, type: $type, isRepack: $isRepack, videoCodec: $videoCodec, bitDepth: $bitDepth, audioChannels: $audioChannels, seeds: $seeds, peers: $peers, size: $size, sizeBytes: $sizeBytes, dateUploaded: $dateUploaded, dateUploadedUnix: $dateUploadedUnix)';
  }

  factory Torrent.fromMap(Map<String, dynamic> data) {
    return Torrent(
      url: data['url'] as String?,
      hash: data['hash'] as String?,
      quality: data['quality'] as String?,
      type: data['type'] as String?,
      isRepack: data['is_repack'] as String?,
      videoCodec: data['video_codec'] as String?,
      bitDepth: data['bit_depth'] as String?,
      audioChannels: data['audio_channels'] as String?,
      seeds: data['seeds'] as int?,
      peers: data['peers'] as int?,
      size: data['size'] as String?,
      sizeBytes: data['size_bytes'] as int?,
      dateUploaded: data['date_uploaded'] as String?,
      dateUploadedUnix: data['date_uploaded_unix'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'hash': hash,
      'quality': quality,
      'type': type,
      'is_repack': isRepack,
      'video_codec': videoCodec,
      'bit_depth': bitDepth,
      'audio_channels': audioChannels,
      'seeds': seeds,
      'peers': peers,
      'size': size,
      'size_bytes': sizeBytes,
      'date_uploaded': dateUploaded,
      'date_uploaded_unix': dateUploadedUnix,
    };
  }

  factory Torrent.fromJson(String data) {
    return Torrent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}