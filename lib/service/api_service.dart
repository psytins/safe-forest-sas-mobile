import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.182:8080/api';

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

  Future<List<dynamic>> fetchNotifications(String userId) async {
    final url = Uri.parse('$_baseUrl/auth/list-notification');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userID': userId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['notifications'];
    } else {
      throw Exception('Failed to load notifications');
    }
  }
// Implement other methods for update and delete if needed
}
