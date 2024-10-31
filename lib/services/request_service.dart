import 'dart:convert';
import 'package:eco_smart/models/request.dart';
import 'package:eco_smart/models/response.dart';
import 'package:eco_smart/utils/system_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestService {
  Future<Response> sendRequest(Request request) async {
    try {
      http.Response response;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      dynamic headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      String url = request.url;

      if (request.params.isNotEmpty) {
        url += '?';
        request.params.forEach((key, value) {
          url += '$key=$value&';
        });
        url = url.substring(0, url.length - 1);
      }

      if (request.method.toUpperCase() == 'GET') {
        response = await http.get(
          Uri.parse(url),
          headers: headers,
        ).timeout(Duration(seconds: request.timeout ?? 30));

      } else if (request.method.toUpperCase() == 'POST') {
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(request.body),
        ).timeout(Duration(seconds: request.timeout ?? 30));

      } else if (request.method.toUpperCase() == 'PUT') {
        response = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(request.body),
        ).timeout(Duration(seconds: request.timeout ?? 30));

      } else if (request.method.toUpperCase() == 'DELETE') {
        response = await http.delete(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(request.body),
        ).timeout(Duration(seconds: request.timeout ?? 30));
        
      } else {
        return Response(
          message: 'Invalid request method',
          data: null,
          code: 400,
          status: 400,
        );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var body = jsonDecode(response.body);

        return Response(
          message: body['message'] ?? 'Success',
          data: body['data'],
          code: body['code'],
          status: response.statusCode,
        );
      } else {
        var body = jsonDecode(response.body);

        return Response(
          message: body['message'] ?? 'Error',
          data: body['data'],
          code: body['code'],
          status: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      logError('Error sending request', e, stackTrace);

      return Response(
        message: 'Error',
        data: e.toString(),
        code: 500,
        status: 500,
      );
    }
  }
}
