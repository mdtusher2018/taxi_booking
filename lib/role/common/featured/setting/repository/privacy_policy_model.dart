class PrivacyPolicyResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<PrivacyPolicy> data;

  PrivacyPolicyResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => PrivacyPolicy.fromJson(e))
          .toList(),
    );
  }
}

class PrivacyPolicy {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrivacyPolicy({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
