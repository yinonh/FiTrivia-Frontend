import 'dart:async';
import 'package:fitrivia/Models/question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Screens/previous_screen.dart';

class PrivateRoomDetail extends StatelessWidget {
  String roomID;
  PrivateRoomDetail({required this.roomID, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TriviaRoom _room = Provider.of<TriviaRoomProvider>(context, listen: false)
        .getRoomById(roomID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _room.name,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: _room.id,
              child: Image.asset(
                _room.picture,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _room.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Text(
              _room.description,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                //Navigator.pop(context);
                Navigator.pushNamed(context, PreviousScreen.routeName,
                    arguments: _room);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '🏁 Start 🏁',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
