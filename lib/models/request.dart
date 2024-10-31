
import 'package:eco_smart/core/constants.dart';

class Request {
  final key = DateTime.now().millisecondsSinceEpoch.toString();
  final DateTime timestamp = DateTime.now();
  final String method;
  final Map<String, dynamic>? body;
  final String? route;
  late int? timeout;
  late String url;
  late Map<String, String> params = {};

  Request({
    required this.method,
    required this.route,
    this.timeout,
    this.body,
  }) {
    url = '$BASE_API_URL/$route';
  }
}
