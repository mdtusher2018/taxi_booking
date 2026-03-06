class TipsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final TipsData data;

  TipsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TipsResponse.fromJson(Map<String, dynamic> json) {
    return TipsResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: TipsData.fromJson(json['data']),
    );
  }
}

class TipsData {
  final String checkoutUrl;

  TipsData({required this.checkoutUrl});

  factory TipsData.fromJson(Map<String, dynamic> json) {
    return TipsData(checkoutUrl: json['checkoutUrl']);
  }
}
