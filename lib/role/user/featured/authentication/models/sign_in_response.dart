class SignInResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Data? data;

  SignInResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final String accessToken;
  final String refreshToken;
  final UserWrapper user;

  Data({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserWrapper.fromJson(json['user']),
    );
  }
}

class UserWrapper {
  final Verification emailVerification;
  final Verification phoneVerification;
  final String id;
  final String email;
  final String phone;
  final String role;
  final String provider;
  final InnerUser user;
  final bool isActive;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserWrapper({
    required this.emailVerification,
    required this.phoneVerification,
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.provider,
    required this.user,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory UserWrapper.fromJson(Map<String, dynamic> json) {
    return UserWrapper(
      emailVerification: Verification.fromJson(json['emailVerification']),
      phoneVerification: Verification.fromJson(json['phoneVerification']),
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      provider: json['provider'] ?? '',
      user: InnerUser.fromJson(json['user']),
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class Verification {
  final int? otp;
  final String? expiresAt;
  final bool status;

  Verification({
    this.otp,
    this.expiresAt,
    required this.status,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      otp: json['otp'],
      expiresAt: json['expiresAt'],
      status: json['status'] ?? false,
    );
  }
}

class InnerUser {
  final String? fcmToken;
  final String id;
  final String fullname;
  final String phone;
  final String email;
  final int rating;
  final String? stripeAccountId;
  final String status;
  final bool isDeleted;
  final DateTime? expireAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InnerUser({
    this.fcmToken,
    required this.id,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.rating,
    this.stripeAccountId,
    required this.status,
    required this.isDeleted,
    this.expireAt,
    this.createdAt,
    this.updatedAt,
  });

  factory InnerUser.fromJson(Map<String, dynamic> json) {
    return InnerUser(
      fcmToken: json['fcmToken'],
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      rating: json['rating'] ?? 0,
      stripeAccountId: json['stripeAccountId'],
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      expireAt: json['expireAt'] != null ? DateTime.tryParse(json['expireAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
