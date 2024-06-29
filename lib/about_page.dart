import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center( // Use Center widget to center the content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            textAlign: TextAlign.center, // Center the text
            text: TextSpan(
              text: 'This app was developed as a companion to the SafeForest service available ',
              style: TextStyle(
                color: Colors.black, // Set text color to black
                fontSize: 20.0, // Reduce the text size
                decoration: TextDecoration.none, // Remove underline
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'here',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      try {
                        await _launchURL();
                      } catch (e) {
                        print('Could not launch URL: $e');
                        _showErrorDialog(context);
                      }
                    },
                ),
                TextSpan(
                  text: ' and is not meant to be used independently.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL() async {
    const url = 'https://www.google.com';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Could not launch the URL.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
