import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:women_safety_app/db/share_pref.dart';
import 'package:women_safety_app/menu/login.dart';
import 'package:women_safety_app/utils/constants.dart';
import 'package:women_safety_app/utils/flutter_background_services.dart';
import 'child/bottom_page.dart';
import 'splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:volume_watcher/volume_watcher.dart';

final navigatorKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefference.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initializeService();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background messages here
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  double currentVolume = 0;
  double initVolume = 0;
  double maxVolume = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      VolumeWatcher.hideVolumeView = true;
      platformVersion = await VolumeWatcher.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    double initVolume = 0;
    double maxVolume = 0;
    try {
      initVolume = await VolumeWatcher.getCurrentVolume;
      maxVolume = await VolumeWatcher.getMaxVolume;
    } on PlatformException {
      platformVersion = 'Failed to get volume.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      this.initVolume = initVolume;
      this.maxVolume = maxVolume;
    });
  }

  void sendEmergencyAlert() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("Emergency Alert: Help me! User is in danger.");
    print("Location: ${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WingWomen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _sendButtonPress() async {
    final Map<String, dynamic> data = {
      'name': 'bhaven', // replace with the actual name
      'number': '123456789', // replace with the actual number
      'location': 'jaipur, india', // replace with the actual location
    };

    final response = await http.post(
      Uri.parse("http://192.168.88.247:2999/button-pressed"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Button press sent successfully!");
    } else {
      print("Failed to send button press!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Button Press App"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendButtonPress,
          child: Text("Press Me"),
        ),
      ),
    );
  }
}
