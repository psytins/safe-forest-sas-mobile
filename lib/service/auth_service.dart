import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://safeforest-prod.azurewebsites.net';
  final storage = FlutterSecureStorage();

  Future<void> storeToken(String token, String userID) async {
    print('Storing token and userID: $userID');
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'userID', value: userID);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userID');
  }

  Future<String?> getUserId() async {
    return await storage.read(key: 'userID');
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/account-authentication');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Log the status code and response body for debugging
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');

        if (responseData.containsKey('token') && responseData.containsKey('userID')) {
          final token = responseData['token'];
          final userId = responseData['userID'].toString(); // Convert userID to string

          if (token != null && userId != null) {
            await storeToken(token, userId);
            return true; // Login successful
          } else {
            print('Token or UserID is null in response');
          }
        } else {
          print('Token or UserID key is missing in response');
        }
      } else {
        print('Login failed with status code: ${response.statusCode}');
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userID');
  }
}
