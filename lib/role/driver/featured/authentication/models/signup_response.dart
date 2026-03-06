class SignupResponse {
  final bool success;
  final int statusCode;
  final String message;

  SignupResponse({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
    );
  }
}
