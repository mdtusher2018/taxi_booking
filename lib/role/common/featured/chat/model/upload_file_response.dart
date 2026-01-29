import 'package:taxi_booking/core/utilitis/api_data_praser_helper.dart';

class UploadFileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final UploadData data;

  UploadFileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UploadFileResponse.fromJson(dynamic json) {
    return UploadFileResponse(
      success: JsonHelper.boolVal(json?['success']),
      statusCode: JsonHelper.intVal(json?['statusCode']),
      message: JsonHelper.stringVal(json?['message']),
      data: UploadData.fromJson(json?['data']),
    );
  }
}

class UploadData {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UploadedFile> file;

  UploadData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
  });

  factory UploadData.fromJson(dynamic json) {
    return UploadData(
      id: JsonHelper.stringVal(json?['_id']),
      createdAt: JsonHelper.parseDate(json?['createdAt']),
      updatedAt: JsonHelper.parseDate(json?['updatedAt']),
      file:
          (json?['file'] as List<dynamic>?)
              ?.map((e) => UploadedFile.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'file': file.map((e) => e.toJson()).toList(),
    };
  }
}

class UploadedFile {
  final String id;
  final String key;
  final String url;

  UploadedFile({required this.id, required this.key, required this.url});

  factory UploadedFile.fromJson(dynamic json) {
    return UploadedFile(
      id: JsonHelper.stringVal(json?['_id']),
      key: JsonHelper.stringVal(json?['key']),
      url: JsonHelper.stringVal(json?['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'key': key, 'url': url};
  }
}
