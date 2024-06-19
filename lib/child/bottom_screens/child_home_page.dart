import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';
import 'package:women_safety_app/db/db_services.dart';

import 'package:women_safety_app/model/contactsm.dart';
import 'package:women_safety_app/widgets/home_widgets/CustomCarouel.dart';
import 'package:women_safety_app/widgets/home_widgets/custom_appBar.dart';

import 'package:women_safety_app/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:women_safety_app/widgets/live_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_safety_app/menu/about.dart';
import 'package:women_safety_app/menu/tips.dart';
import 'package:women_safety_app/menu/login.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:women_safety_app/child/HotwordDetection.dart';
import 'package:shake_event/shake_event.dart';











class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   
  int qIndex = 0;
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  
 

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    final Telephony telephony = Telephony.instance;
    await telephony.requestPhoneAndSmsPermissions;
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _curentPosition = position;
        print(_curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(6);
    });
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();

    String messageBody =
        "https://maps.google.com/?daddr=${_curentPosition!.latitude},${_curentPosition!.longitude}";
    if (await _isPermissionGranted()) {
      contactList.forEach((element) {
       
      });
    } else {
      Fluttertoast.showToast(msg: "something wrong");
    }
  }
  void _handleSOSButtonPressed() async {
  
  List<TContact> contactList = await DatabaseHelper().getContactList();

  
  String messageBody =
      "I am in trouble! Please help!\nLocation: $_curentAddress\nGoogle Maps: https://maps.google.com/?daddr=${_curentPosition!.latitude},${_curentPosition!.longitude}";

  
  for (TContact contact in contactList) {
    await _sendSms("${contact.number}", messageBody);
  }

  
  String emergencyNumber = "tel:911";
  await _makeEmergencyCall(emergencyNumber);
}
Future<void> _sendSms(String phoneNumber, String message) async {
  // Use the 'url_launcher' package to send SMS
  String smsUrl = "sms:$phoneNumber?body=$message";
  await launch(smsUrl);
}

Future<void> _makeEmergencyCall(String phoneNumber) async {
  // Use the 'url_launcher' package to make a call
  await launch(phoneNumber);
}



  @override
  void initState() {
   getRandomQuote();
   super.initState();
   _getPermission();
    _getCurrentLocation();
     ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

   
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0Xffe2eefa),
      appBar: AppBar(
       backgroundColor:Color(0xFFF28282), 
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            
            icon: Icon(Icons.menu),
            
            onPressed: () {
              
              Scaffold.of(context).openDrawer();
              
            },
          );
        },
      ),
      title: Text("Wing Women"),
    ),drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF28282), 
            ),
            child: Text(
              'User Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
    //       ListTile(
    //         title: Text('Profile'),
    //         onTap: () {
    //          Navigator.pop(context); 
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProfileScreen()),
    // );
    //         },
    //       ),
          ListTile(
            title: Text('About'),
            onTap: () {
               Navigator.pop(context); 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutScreen()),
    );
            },
          ),
          ListTile(
            title: Text('Tips'),
            onTap: () {
             Navigator.pop(context); 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TipsScreen()),
    );
            },
          ),ListTile(
            title: Text('Login'),
            onTap: () {
             Navigator.pop(context); 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
            },
          ),

        ],
      ),
    ),
      
  
        

        
        

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                  SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Explore your power",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                   
                    SizedBox(height: 10),
                    CustomCarouel(),
                     SizedBox(height: 20),
                  ElevatedButton(
                  onPressed: () {
                  _handleSOSButtonPressed();
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xfffa3e3b), 
                  padding: EdgeInsets.all(45), 
                  shape: CircleBorder(), 
                  ),
                  child: Text(
                  'SOS',
                  style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:Colors.white,
                  ),
                  ),
                  ),
                  SizedBox(height: 20),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Explore LiveSafe",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    



                    SizedBox(height: 10),
                    LiveSafe(),
                    SafeHome(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    
}

