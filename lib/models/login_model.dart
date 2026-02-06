class LoginResponse {
  final bool status;
  final String message;
  final String? token;
  final String? isStaff;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.isStaff,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      isStaff: json['is_staff'],
    );
  }
}
