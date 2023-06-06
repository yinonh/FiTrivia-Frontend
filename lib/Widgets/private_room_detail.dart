import 'dart:async';
import 'package:fitrivia/Models/question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Providers/user_provider.dart';
import '../Screens/previous_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context).translate("Room Details"),
          ),
        ),
      ),
      body: FutureBuilder<TriviaRoom>(
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
          return Column(
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
            ],
          );
        },
      ),
    );
  }
}
