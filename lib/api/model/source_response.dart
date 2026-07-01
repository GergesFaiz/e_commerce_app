import 'package:json_annotation/json_annotation.dart';

import 'data.dart';
import 'meta_data.dart';

part 'source_response.g.dart';

@JsonSerializable()
class SourceResponse {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "status_message")
  final String? statusMessage;

  // استثنيناهم من الـ generator وهنعملهم يدوي
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Data? data;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MetaData? meta;

  SourceResponse({this.status, this.statusMessage, this.data, this.meta});

  factory SourceResponse.fromJson(Map<String, dynamic> json) {
    final base = _$SourceResponseFromJson(json);
    return SourceResponse(
      status: base.status,
      statusMessage: base.statusMessage,
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      meta: json['@meta'] != null
          ? MetaData.fromJson(json['@meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = _$SourceResponseToJson(this);
    if (data != null) map['data'] = data!.toJson();
    if (meta != null) map['@meta'] = meta!.toJson();
    return map;
  }
}