// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceResponse _$SourceResponseFromJson(Map<String, dynamic> json) =>
    SourceResponse(
      status: json['status'] as String?,
      statusMessage: json['status_message'] as String?,
    );

Map<String, dynamic> _$SourceResponseToJson(SourceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'status_message': instance.statusMessage,
    };
