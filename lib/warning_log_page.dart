import 'dart:convert';
import 'package:flutter/material.dart';
import 'auth_service.dart';
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView(
        children: warnings.map((warning) => WarningTile(warning: warning)).toList(),
      ),
    );
  }
}

class WarningTile extends StatefulWidget {
  final Warning warning;

  WarningTile({required this.warning});

  @override
  _WarningTileState createState() => _WarningTileState();
}

class _WarningTileState extends State<WarningTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _isExpanded,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Camera ID: ${widget.warning.cameraId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${widget.warning.date}'),
                    Text('Sensitivity: ${widget.warning.sensitivity}'), // Display sensitivity here
                  ],
                ),
              );
            },
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Image.network(widget.warning.imageUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}