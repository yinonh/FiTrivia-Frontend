import 'dart:async';
import 'package:fitrivia/Widgets/scoreboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
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
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
    TriviaRoomProvider _triviaRoomsProvider =
        Provider.of<TriviaRoomProvider>(context, listen: false);
    String roomName = _triviaRoomsProvider.convertCategory(widget.category);
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
              SizedBox(
                height: 25,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                                .translate('Number of Questions:') +
                            ' $_numberOfQuestions',
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
                        AppLocalizations.of(context)
                                .translate('Rest Time (Seconds):') +
                            ' $_restTime',
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
                        AppLocalizations.of(context)
                                .translate('Exercise Time (Seconds):') +
                            ' $_exerciseTime',
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
                    id: widget.category,
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
                  if (!await _triviaRoomsProvider
                      .isRoomExistsById(widget.category)) {
                    await _triviaRoomsProvider.addStaticRoom(room);
                  }
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, PreviousScreen.routeName,
                      arguments: room);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('🏁 Start 🏁'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context).translate('🏆 Scoreboard 🏆'),
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 400,
                child: FutureBuilder(
                  future: _triviaRoomsProvider.get_scoreboard(
                      widget.category, _numberOfQuestions),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('No Scores Yet'),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Scoreboard(
                            userScores: snapshot.data!,
                            currentUserID: currentUser,
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
      ),
    );
  }
}
