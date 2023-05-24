import 'package:fitrivia/Screens/trivia_rooms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


import '../Providers/music_provider.dart';
import '../Screens/add_room_screen.dart';
import '../Screens/wheel.dart';
import '../Screens/auth_screen.dart';
import '../Screens/connect_us_screen.dart';
import '../Screens/settings_screen.dart';

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
              Navigator.pushReplacementNamed(context, AddRoom.routeName);
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
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, UserDetailsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await Provider.of<MusicProvider>(context, listen: false).stopBgMusic();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
