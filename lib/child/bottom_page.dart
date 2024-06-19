import 'package:flutter/material.dart';
import 'package:women_safety_app/child/bottom_screens/add_contacts.dart';

import 'package:women_safety_app/child/bottom_screens/child_home_page.dart';
import 'package:women_safety_app/child/bottom_screens/profile_page.dart';
import 'package:women_safety_app/child/bottom_screens/review_page.dart';


class BottomPage extends StatefulWidget {
  BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactsPage(),
    
    CheckUserStatusBeforeChatOnProfile(),
    ReviewPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
         backgroundColor: Color.fromARGB(255, 245, 244, 244),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
              label: 'home',
              icon: Icon(
                Icons.home, color: Color.fromARGB(255, 0, 0, 0)
                ,
              
              )),
          BottomNavigationBarItem(
              label: 'contacts',
              icon: Icon(
                Icons.contacts,color: Color.fromARGB(255, 0, 0, 0)
              )),
          
         
        ],
      ),
    );
  }
}
