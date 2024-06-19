import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Wing Women',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'A safety app designed for women to ensure their security and provide peace of mind.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Developed by Digital Diplomats',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // You can add functionality to navigate to a feedback or contact page
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
              child: Text('Provide Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
