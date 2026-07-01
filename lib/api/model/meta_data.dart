import 'package:json_annotation/json_annotation.dart';

part 'meta_data.g.dart';

@JsonSerializable()
class MetaData {
  @JsonKey(name: "api_version")
  final int? apiVersion;
  @JsonKey(name: "execution_time")
  final String? executionTime;

  MetaData({this.apiVersion, this.executionTime});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return _$MetaDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MetaDataToJson(this);
  }
}
