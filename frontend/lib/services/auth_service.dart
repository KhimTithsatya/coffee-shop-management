import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // For Flutter Web running in Chrome on the same computer.
  static const String baseUrl = 'http://localhost:8080/api/auth';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      }),
    );

    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'message': 'Registration successful'};
    }

    final message = decoded is Map<String, dynamic>
        ? decoded['message'] ?? decoded['error'] ?? response.body
        : response.body;

    throw Exception(message.toString().isEmpty
        ? 'Registration failed (${response.statusCode})'
        : message.toString());
  }
}
