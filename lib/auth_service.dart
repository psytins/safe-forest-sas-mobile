import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.177:8080';

  final storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/account-authentication');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Assuming successful login response
      return true;
    } else {
      // Handle login failure
      return false;
    }
  }
}
