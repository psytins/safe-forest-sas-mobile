import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safe_forest_mobile/service/notification_service.dart';
import 'service/api_service.dart';
import 'service/auth_service.dart';
import 'login_page.dart';
import 'model/warning.dart';
import 'warning_log_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Example warning data
  Warning? exampleWarning;
  ApiService _apiService = ApiService();
  String? _userId;
  List<dynamic>? _notifications;
  Timer? _timer;
  final AuthService _authService = AuthService();

  void _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    // Set exampleWarning initially with mock data
    exampleWarning = Warning(
      cameraId: 'Camera 1',
      date: DateTime.now(),
      sensitivity: 95,
      imageUrl: 'https://via.placeholder.com/150',
    );
    _fetchNotifications();
    // Set up a timer to fetch notifications every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchNotifications();
    });
  }

  void dismissWarning() {
    setState(() {
      exampleWarning = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchNotifications() async {
    try {
      _userId = await _authService.getUserId();
      if (_userId != null) {
        List<dynamic> newNotifications = await _apiService.fetchNotifications(_userId!);

        // Compare lengths to detect changes
        if (_notifications == null || _notifications!.length != newNotifications.length) {
          setState(() {
            _notifications = newNotifications;
          });
          // Show notification when updates are detected
          NotificationService().showNotification(title: 'New Detection!', body: 'Press to go to app.');
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }


  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform logout actions here, such as navigating to login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xFFC0D966),
      ),
      backgroundColor: Color(0xFF22252E), // Set background color to #22252E
      drawer: Drawer(
        child: Container(
          color: Color(0xFF22252E), // Set drawer background color to #22252E
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFC0D966), // Set drawer header background color to #C0D966
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40, // Adjust the radius to resize the image
                      backgroundImage: AssetImage('assets/images/safe-forest.png'), // Replace with your image asset path
                    ),
                    SizedBox(height: 10),
                    Text(
                      'SafeForest Companion',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Warning Log',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WarningLogPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Log out',
                  style: TextStyle(color: Colors.red), // Set text color to red
                ),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF22252E), // Set container background color to #22252E
        child: Center(
          child: exampleWarning != null
              ? Center( // Wrap with Center to horizontally and vertically center the content
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 70% of screen width
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Set warning details container background color to white
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Latest Warning',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  //SizedBox(height: 10),
                  ListTile(
                    title: Text('Camera ID: ${exampleWarning!.cameraId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${exampleWarning!.date}'),
                        Text('Sensitivity: ${exampleWarning!.sensitivity}'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    height: 275, // Adjust the height as per your requirement
                    child: Image.network(exampleWarning!.imageUrl),
                  ),
                  SizedBox(height: 10),
                  /*ElevatedButton(
                    onPressed: (){
                  NotificationService()
                      .showNotification(title: 'Sample title', body: 'It works!');
                  },
                    child: Text('Dismiss'),
                  ),*/
                ],
              ),
            ),
          )
              : Center( // Center the text if there's no warning
            child: Text(
              'The latest warning will display here.',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ),
        ),
      ),

    );
  }
}
