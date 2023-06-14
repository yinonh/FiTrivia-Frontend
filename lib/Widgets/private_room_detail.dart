import 'dart:async';
import 'package:fitrivia/Models/question.dart';
import 'package:fitrivia/Widgets/scoreboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Providers/user_provider.dart';
import '../Screens/previous_screen.dart';
import '../Screens/edit_room.dart';

class PrivateRoomDetail extends StatefulWidget {
  String roomID;

  PrivateRoomDetail({required this.roomID, Key? key}) : super(key: key);

  @override
  State<PrivateRoomDetail> createState() => _PrivateRoomDetailState();
}

class _PrivateRoomDetailState extends State<PrivateRoomDetail> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> removeRoom(BuildContext context, String roomId) async {
    // Show confirmation dialog to the user
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate('Confirm'),
        ),
        content: Text(
          AppLocalizations.of(context)
              .translate('Are you sure you want to delete this room?'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.of(context).translate('No'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context).translate('Yes'),
            ),
          ),
        ],
      ),
    );

    // If the user confirms, delete the room
    if (confirm == true) {
      try {
        await Provider.of<TriviaRoomProvider>(context, listen: false)
            .removeRoom(roomId);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString().substring(11))));
      }
    }
  }

  Future<void> share(BuildContext context, TriviaRoom room) async {
    String inviteMessage = AppLocalizations.of(context)
            .translate('Come join my room:') +
        ' ${room.id} ${!room.isPublic ? AppLocalizations.of(context).translate('Password') + ': ${room.password}' : ''}';
    await Clipboard.setData(ClipboardData(text: inviteMessage));
    Share.share(inviteMessage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)
              .translate('Invite message copied to clipboard successfully.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TriviaRoom>(
      future: Provider.of<TriviaRoomProvider>(context, listen: false)
          .getTriviaRoomById(widget.roomID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(AppLocalizations.of(context).translate("Error") +
                  ': ${snapshot.error}'));
        }
        final TriviaRoom room = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            actions: FirebaseAuth.instance.currentUser!.uid == room.managerID
                ? <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, EditRoom.routeName,
                              arguments: room.id);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share,
                          size: 30,
                        ),
                        onPressed: () {
                          share(context, room);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                        ),
                        onPressed: () async {
                          await removeRoom(context, room.id);
                        },
                      ),
                    ),
                  ]
                : null,
            title: Center(
              child: Text(
                AppLocalizations.of(context).translate("Room Details"),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        room.name,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        room.description,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Exercise Time: ${room.exerciseTime}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Rest Time: ${room.restTime}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Number of questions: ${room.questions.length}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(width: 16),
                          FutureBuilder<String?>(
                            future: Provider.of<UserProvider>(context)
                                .getUsernameByUserId(room.managerID),
                            builder: (BuildContext context,
                                AsyncSnapshot<String?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                    "..."); // Display a loading indicator while fetching data
                              } else if (snapshot.hasError) {
                                return Text(
                                    "Error occurred while fetching manager's name"); // Display an error message if an error occurred
                              } else if (snapshot.hasData) {
                                final managerName = snapshot.data;
                                return Text(
                                  managerName != null
                                      ? "Manager name: $managerName"
                                      : "Manager not found",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ); // Display the manager's name if available, otherwise display a default message
                              } else {
                                return Text(
                                    "Manager not found"); // Display a default message if manager's name is not available
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, PreviousScreen.routeName,
                          arguments: room);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        AppLocalizations.of(context).translate('🏁 Start 🏁'),
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                Text(
                  AppLocalizations.of(context).translate('🏆 Scoreboard 🏆'),
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 400,
                  child: FutureBuilder(
                    future: Provider.of<TriviaRoomProvider>(context, listen: false).get_scoreboard(room.id,room.questions.length),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(height: 70,),
                              Text(
                                AppLocalizations.of(context).translate('No Scores Yet'),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Scoreboard(
                              userScores: snapshot.data!,
                              currentUserID: FirebaseAuth.instance.currentUser!.uid,
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                          AppLocalizations.of(context).translate('Error'),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
