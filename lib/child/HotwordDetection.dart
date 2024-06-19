import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:geolocator/geolocator.dart';

class HotwordDetection {
  stt.SpeechToText _speech;
  String _hotword;
  int _hotwordCount = 0;
  final int _hotwordThreshold = 3;
  List<String> _emergencyContacts = [];

  HotwordDetection(this._hotword) : _speech = stt.SpeechToText();

  void setEmergencyContacts(List<String> contacts) {
    _emergencyContacts = contacts;
  }

  Future<void> startListening() async {
    if (await _speech.initialize()) {
      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.toLowerCase() == _hotword.toLowerCase()) {
            _hotwordCount++;
            if (_hotwordCount >= _hotwordThreshold) {
              sendEmergencyAlert();
              _hotwordCount = 0;
            }
          }
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
  }

  void sendEmergencyAlert() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Combine alert message with location information
    String alertMessage = "Emergency Alert: Help me! User is in danger.";
    String locationMessage = "Location: ${position.latitude}, ${position.longitude}";
    String combinedMessage = "$alertMessage\n$locationMessage";

    // Iterate through emergency contacts and send the combined message
    for (String contact in _emergencyContacts) {
      // Implement your logic to send the combined message to each emergency contact
      // This could involve sending SMS, making calls, or using a messaging service
      // For example, you might use a package like 'sms' or 'url_launcher' to send an SMS or make a call
      // You may need to integrate with an API or service for sending messages
      // For simplicity, this example just prints the message to the console
      print("Sending to emergency contact: $contact\n$combinedMessage");
    }
  }
}
