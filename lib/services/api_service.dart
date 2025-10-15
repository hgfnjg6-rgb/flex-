import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? base}) : baseUrl = base ?? AppConfig.apiBaseUrl;

  Future<Map<String, dynamic>> ping() async {
    // Placeholder for REST calls
    final url = Uri.parse('$baseUrl/ping');
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        return json.decode(resp.body) as Map<String, dynamic>;
      }
      return {'error': 'status ${resp.statusCode}'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
