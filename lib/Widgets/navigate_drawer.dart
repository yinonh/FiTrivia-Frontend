import 'package:fitrivia/Screens/trivia_rooms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Screens/wheel.dart';
import '../Screens/auth_screen.dart';
import '../Screens/connect_us_screen.dart';

class NavigateDrawer extends StatelessWidget {
  const NavigateDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, TriviaRooms.routeName);
              },
              child: Center(
                child: Image.asset(
                  "assets/logo2.png",
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Create New Room'),
            onTap: () {
              // Implement your logic for creating a new room here
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('Surprise Me'),
            onTap: () {
              Navigator.pushReplacementNamed(context, WheelScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Connect us'),
            onTap: () {
              Navigator.pushReplacementNamed(context, ConnectUsPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
