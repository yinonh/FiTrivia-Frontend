import 'dart:async';
import 'package:fitrivia/Models/question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
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
            return Center(child: Text(AppLocalizations.of(context).translate("Error") + ': ${snapshot.error}'));
          }
          final TriviaRoom room = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 8),
                    Text(
                      room.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, PreviousScreen.routeName,
                            arguments: room);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context).translate('🏁 Start 🏁'),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
