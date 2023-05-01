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
    String roomName = Provider.of<TriviaRoomProvider>(context, listen: false)
        .convertCategory(roomID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          roomName,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: roomID,
              child: Image.asset(
                'assets/$roomID.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Album Title',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Text(
              'Artist Name',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                List<QuizQuestion> questions =
                    await Provider.of<TriviaRoomProvider>(context,
                            listen: false)
                        .fetchQuestions(roomID, 3);
                TriviaRoom room = TriviaRoom(
                  id: '',
                  name: roomName,
                  description: '',
                  managerID: '',
                  questions: questions,
                  exerciseTime: 10,
                  restTime: 5,
                  scoreboard: {},
                  picture: '',
                  isPublic: true,
                  password: '',
                );
                //Navigator.pop(context);
                Navigator.pushNamed(context, PreviousScreen.routeName,
                    arguments: room);
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
