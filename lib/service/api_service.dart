import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_forest_mobile/model/warning.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.177:8080/api'; //Change to production IP accordingly

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

  Future<List<Warning>> fetchWarnings(String userId, String authToken) async {
    final url = Uri.parse('$_baseUrl/camera/list-last-detection');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'userID': userId}),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List<dynamic> detections = decodedData['detections'];
      List<Warning> fetchedWarnings = detections.map((item) => Warning.fromJson(item)).toList();

      // Sort warnings by date in descending order
      fetchedWarnings.sort((a, b) => b.date.compareTo(a.date));

      return fetchedWarnings;
    } else {
      throw Exception('Failed to fetch warnings: ${response.body}');
    }
  }
}
