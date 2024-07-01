import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service/auth_service.dart';
import 'model/warning.dart';
import 'package:http/http.dart' as http;

class WarningLogPage extends StatefulWidget {
  @override
  _WarningLogPageState createState() => _WarningLogPageState();
}

class _WarningLogPageState extends State<WarningLogPage> {
  final AuthService _authService = AuthService(); // Instantiate AuthService

  List<Warning> warnings = [];
  bool isLoading = true;
  String? errorMessage;

  // Scroll controller for the ListView
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getTokenAndFetchWarnings();
  }

  Future<void> getTokenAndFetchWarnings() async {
    try {
      String? authToken = await _authService.getToken();
      print('Auth token: $authToken');
      if (authToken != null) {
        String? userId = await _authService.getUserId(); // Get userId from AuthService
        print('Retrieved userID: $userId');
        if (userId != null) {
          print('User ID: $userId');
          await fetchWarnings(userId, authToken);
        } else {
          setState(() {
            errorMessage = 'UserID is null';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Token is null or not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch token: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchWarnings(String userId, String authToken) async {
    try {
      final url = Uri.parse('http://192.168.1.177:8080/api/camera/list-last-detection');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'userID': userId}),
      );

      print('Fetch warnings response status: ${response.statusCode}');
      print('Fetch warnings response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> detections = decodedData['detections'];
        List<Warning> fetchedWarnings = detections.map((item) => Warning.fromJson(item)).toList();

        fetchedWarnings.forEach((warning) {
          print('Fetched Warning: ${warning.cameraId}, ${warning.date}, ${warning.imageUrl}');
        });

        setState(() {
          warnings = fetchedWarnings;
          isLoading = false;
        });

        // Scroll to the top of the list when new data is fetched
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        setState(() {
          errorMessage = 'Failed to fetch warnings: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch warnings: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warning Log'),
        backgroundColor: Color(0xFFC0D966),
      ),
      backgroundColor: Color(0xFF22252E), // Set background color here
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView(
        controller: _scrollController,
        children: warnings.map((warning) => WarningTile(warning: warning)).toList(),
      ),
    );
  }
}

class WarningTile extends StatelessWidget {
  final Warning warning;

  WarningTile({required this.warning});

  @override
  Widget build(BuildContext context) {
    return Container( // Wrap Card with Container
      margin: EdgeInsets.all(10.0),
      child: Card(
        color: Color(0xFFF2F2F2), // Set background color to #C0D966
        child: ExpansionTile(
          title: Text('Camera ID: ${warning.cameraId}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${DateFormat.yMMMd().add_jm().format(warning.date)}'),
              Text('Sensitivity: ${warning.sensitivity}'),
            ],
          ),
          children: [
            Image.network(warning.imageUrl),
          ],
        ),
      ),
    );
  }
}