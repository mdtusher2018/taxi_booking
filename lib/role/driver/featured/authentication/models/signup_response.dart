class SignupResponse {
  final bool success;
  final int statusCode;
  final String message;
  final String accessToken;

  SignupResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.accessToken,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      accessToken: json["data"]?['sendOtp']?['token'] ?? "",
    );
  }
}
