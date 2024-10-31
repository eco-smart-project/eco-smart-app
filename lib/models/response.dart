class Response {
  final String message;
  final dynamic data;
  final int code;
  final int status;

  Response({
    required this.message,
    required this.data,
    required this.code,
    required this.status,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      message: json['message'],
      data: json['data'],
      code: json['code'],
      status: json['status'],
    );
  }
}
