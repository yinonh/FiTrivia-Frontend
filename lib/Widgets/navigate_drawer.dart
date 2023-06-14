import 'dart:typed_data';

import 'package:fitrivia/Screens/trivia_rooms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Widgets/language_dropdown.dart';
import '../Providers/music_provider.dart';
import '../Providers/user_provider.dart';
import '../Screens/add_room_screen.dart';
import '../Screens/wheel.dart';
import '../Screens/auth_screen.dart';
import '../Screens/connect_us_screen.dart';
import '../Screens/settings_screen.dart';

class NavigateDrawer extends StatelessWidget {
  const NavigateDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.primaryContainer,
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
          FutureBuilder<String?>(
            future: Provider.of<UserProvider>(context)
                .checkExistingProfileImage(
                    FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              final imageUrl = snapshot.data;
              return FutureBuilder<Uint8List?>(
                future: imageUrl != null
                    ? Provider.of<UserProvider>(context)
                        .loadImageFromUrl(imageUrl)
                    : null,
                builder: (context, snapshot) {
                  final imageBytes = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: ListTile(
                      //style: ListTileStyle(),
                      leading: CircleAvatar(
                        backgroundImage:
                            imageBytes != null ? MemoryImage(imageBytes) : null,
                        backgroundColor:
                            imageBytes != null ? null : colorScheme.primary,
                        child: imageBytes == null
                            ? Icon(
                                Icons.person,
                                color: colorScheme.secondary,
                              )
                            : null,
                      ),
                      tileColor: colorScheme.secondary,
                      title: FutureBuilder<String?>(
                        future: Provider.of<UserProvider>(context)
                            .getUsernameByUserId(
                                FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          final username = snapshot.data;
                          return Text(
                            '${AppLocalizations.of(context).translate('Hello')} ${username ?? ''}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(
              AppLocalizations.of(context).translate('Create New Room'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, AddRoom.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text(
              AppLocalizations.of(context).translate('Surprise Me'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, WheelScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text(
              AppLocalizations.of(context).translate('Connect Us'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, ConnectUsPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              AppLocalizations.of(context).translate('Settings'),
            ),
            onTap: () {
              Navigator.pushNamed(context, UserDetailsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              AppLocalizations.of(context).translate('Logout'),
            ),
            onTap: () async {
              await Provider.of<MusicProvider>(context, listen: false)
                  .stopBgMusic();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          ),
          LanguageDropdown(),
        ],
      ),
    );
  }
}
