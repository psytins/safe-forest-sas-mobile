import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or a loading screen
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Token exists, navigate to Home page
          return MaterialApp(
            title: 'Flutter Login',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomePage(),
          );
        } else {
          // No token found, navigate to Login page
          return MaterialApp(
            title: 'Flutter Login',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginPage(),
          );
        }
      },
    );
  }
}
