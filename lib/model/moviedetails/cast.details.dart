import 'dart:convert';
import 'data.details.dart';
import 'meta.details.dart';

class MovieModel {
  String? status;
  String? statusMessage;
  Data? data;
  Meta? meta;

  MovieModel({this.status, this.statusMessage, this.data, this.meta});

  factory MovieModel.fromMap(Map<String, dynamic> jsonMap) {
    return MovieModel(
      status: jsonMap['status'] as String?,
      statusMessage: jsonMap['status_message'] as String?,
      data: jsonMap['data'] == null
          ? null
          : Data.fromMap(jsonMap['data'] as Map<String, dynamic>),
      meta: jsonMap['@meta'] == null 
          ? null
          : Meta.fromMap(jsonMap['@meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'status_message': statusMessage,
      'data': data?.toMap(),
      '@meta': meta?.toMap(),
    };
  }

  factory MovieModel.fromJson(String data) {
    return MovieModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}