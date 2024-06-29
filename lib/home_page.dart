import 'package:flutter/material.dart';
import 'package:safe_forest_mobile/warning_log_page.dart';
import 'about_page.dart'; // Import the AboutPage
import 'main.dart';
import 'model/warning.dart'; // Import your Warning model

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Warning? exampleWarning;

  @override
  void initState() {
    super.initState();
    // Set exampleWarning initially with mock data
    exampleWarning = Warning(
      cameraId: 'Camera 1',
      date: '2024-06-25',
      sensitivity: 'High',
      imageUrl: 'https://via.placeholder.com/150',
    );
  }

  void dismissWarning() {
    setState(() {
      exampleWarning = null; // Dismiss the warning by setting exampleWarning to null
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Perform logout actions here, such as navigating to login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Warning Log'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarningLogPage()),
                );
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            ListTile(
              title: Text('Log out', style: TextStyle(color: Colors.red)),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
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
