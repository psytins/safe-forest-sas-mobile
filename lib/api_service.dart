import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://your-server-ip:8080/api';

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

// Implement other methods for update and delete if needed
}
