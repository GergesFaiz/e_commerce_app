// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      apiVersion: (json['api_version'] as num?)?.toInt(),
      executionTime: json['execution_time'] as String?,
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'api_version': instance.apiVersion,
      'execution_time': instance.executionTime,
    };
