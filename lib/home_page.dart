import 'package:flutter/material.dart';
import 'auth_service.dart';
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
  }

  void dismissWarning() {
    setState(() {
      exampleWarning = null;
    });
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
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF22252E), // Set background color to #22252E
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFC0D966), // Set background color to #22252E
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
      body: Center(
        child: exampleWarning != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latest Warning'),
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
              child: Image.network(exampleWarning!.imageUrl),
            ),
            ElevatedButton(
              onPressed: dismissWarning,
              child: Text('Dismiss'),
            ),
          ],
        )
            : Text('No warnings to display'), // Display if there's no warning
      ),
    );
  }
}
