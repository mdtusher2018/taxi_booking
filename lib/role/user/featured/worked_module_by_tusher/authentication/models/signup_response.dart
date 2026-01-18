class SignupResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CreateUserData data;

  SignupResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: CreateUserData.fromJson(json["data"]),
    );
  }
}

class CreateUserData {
  final SendOtp sendOtp;

  CreateUserData({required this.sendOtp});

  factory CreateUserData.fromJson(Map<String, dynamic> json) {
    return CreateUserData(sendOtp: SendOtp.fromJson(json["sendOtp"]));
  }
}

class SendOtp {
  final String token;

  SendOtp({required this.token});

  factory SendOtp.fromJson(Map<String, dynamic> json) {
    return SendOtp(token: json["token"]);
  }
}
