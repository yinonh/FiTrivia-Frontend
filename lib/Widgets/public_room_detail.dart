import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/question.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Screens/previous_screen.dart';

class PublicRoomDetail extends StatefulWidget {
  String category;
  PublicRoomDetail({required this.category, Key? key}) : super(key: key);

  @override
  State<PublicRoomDetail> createState() => _PublicRoomDetailState();
}

class _PublicRoomDetailState extends State<PublicRoomDetail> {
  int _numberOfQuestions = 5;
  int _restTime = 5;
  int _exerciseTime = 15;

  @override
  Widget build(BuildContext context) {
    String roomName = Provider.of<TriviaRoomProvider>(context, listen: false)
        .convertCategory(widget.category);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            roomName,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: widget.category,
                child: Image.asset(
                  'assets/${widget.category}.png',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Number of Questions: $_numberOfQuestions',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      Slider(
                        value: _numberOfQuestions.toDouble(),
                        min: 2,
                        max: 20,
                        divisions: 18,
                        label: _numberOfQuestions.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _numberOfQuestions = value.toInt();
                          });
                        },
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Rest Time (Seconds): $_restTime',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      Slider(
                        value: _restTime.toDouble(),
                        min: 5,
                        max: 30,
                        divisions: 5,
                        label: _restTime.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _restTime = value.toInt();
                          });
                        },
                      ),
                      SizedBox(height: 40.0),
                      Text(
                        'Exercise Time (Seconds): $_exerciseTime',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      Slider(
                        value: _exerciseTime.toDouble(),
                        min: 5,
                        max: 30,
                        divisions: 5,
                        label: _exerciseTime.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _exerciseTime = value.toInt();
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<QuizQuestion> questions =
                      await Provider.of<TriviaRoomProvider>(context,
                              listen: false)
                          .fetchQuestions(widget.category, _numberOfQuestions);
                  TriviaRoom room = TriviaRoom(
                    id: '',
                    name: roomName,
                    description: '',
                    managerID: '',
                    questions: questions,
                    exerciseTime: _exerciseTime,
                    restTime: _restTime,
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
      ),
    );
  }
}
