import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safety Tips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SafetyTip(
              title: 'Be Aware of Your Surroundings',
              description:
              'Pay attention to your surroundings and trust your instincts. If something feels off, take action to stay safe.',
            ),
            SafetyTip(
              title: 'Share Your Location',
              description:
              'Share your live location with trusted contacts, especially when traveling alone or in unfamiliar areas.',
            ),
            SafetyTip(
              title: 'Emergency Contacts',
              description:
              'Keep emergency contacts readily available. Program them into your phone and have a written list in case of emergencies.',
            ),
            SafetyTip(
              title: 'Use Safety Apps',
              description:
              'Utilize safety apps that provide features like emergency alerts, location sharing, and quick access to help.',
            ),
            // Add more SafetyTip widgets for additional tips
          ],
        ),
      ),
    );
  }
}

class SafetyTip extends StatelessWidget {
  final String title;
  final String description;

  const SafetyTip({
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
