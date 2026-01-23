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

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: UploadData.fromJson(json['data']),
    );
  }
}

class UploadData {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UploadedFile> file;

  UploadData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
  });

  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      file: (json['file'] as List)
          .map((e) => UploadedFile.fromJson(e))
          .toList(),
    );
  }
}

class UploadedFile {
  final String id;
  final String key;
  final String url;

  UploadedFile({required this.id, required this.key, required this.url});

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(id: json['_id'], key: json['key'], url: json['url']);
  }
}
