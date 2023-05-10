import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Widgets/navigate_drawer.dart';
import '../Screens/trivia_rooms.dart';
import '../Models/question.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';

class EditRoom extends StatefulWidget {
  static const routeName = '/edit_room';
  final String roomID;

  const EditRoom({Key? key, required this.roomID}) : super(key: key);

  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  int _currentStep = 0;
  final GlobalKey<FormState> _questionsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _roomFormKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late int _exerciseTime;
  late int _restTime;
  late TextEditingController _passwordController;
  late bool _isPublic;
  List<QuizQuestion> _quizQuestions = [];
  bool requestSent = false;
  bool reload = true;

  Future<void> _getRoomDetails() async {
    TriviaRoom triviaRoom =
        await Provider.of<TriviaRoomProvider>(context, listen: false)
            .getTriviaRoomById(widget.roomID);
    _nameController = TextEditingController(text: triviaRoom.name);
    _descriptionController =
        TextEditingController(text: triviaRoom.description);
    _exerciseTime = triviaRoom.exerciseTime;
    _restTime = triviaRoom.restTime;
    _passwordController = TextEditingController(text: triviaRoom.password);
    _quizQuestions = triviaRoom.questions;
    _isPublic = triviaRoom.isPublic;
    setState(() {
      reload = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRoomDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigateDrawer(),
      appBar: AppBar(
        title: Center(child: Text('Edit Room')),
      ),
      body: reload
          ? Center(child: CircularProgressIndicator())
          : Stepper(
              controlsBuilder: (context, _) {
                return Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        if (_currentStep == 0) {
                          if (_roomFormKey.currentState!.validate()) {
                            _roomFormKey.currentState!.save();
                            setState(() => _currentStep += 1);
                          }
                        } else {
                          if (_questionsFormKey.currentState!.validate()) {
                            _questionsFormKey.currentState!.save();
                            setState(() {
                              requestSent = true;
                            });
                            if (await Provider.of<TriviaRoomProvider>(context,
                                    listen: false)
                                .editTriviaRoom(
                                    widget.roomID,
                                    TriviaRoom(
                                        id: widget.roomID,
                                        name: _nameController.text,
                                        description:
                                            _descriptionController.text,
                                        managerID: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        questions: _quizQuestions,
                                        exerciseTime: _exerciseTime,
                                        restTime: _restTime,
                                        scoreboard: {},
                                        picture: '',
                                        isPublic: _isPublic,
                                        password: _passwordController.text))) {
                              Navigator.of(context)
                                  .pushReplacementNamed(TriviaRooms.routeName);
                            } else {
                              setState(() {
                                requestSent = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Server Error, try again"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Correct the question data"),
                              ),
                            );
                          }
                          // setState(() => _currentStep += 1);
                        }
                      },
                      child: requestSent
                          ? const Text('Send...')
                          : const Text('CONTINUE'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_currentStep == 0) {
                          Navigator.of(context)
                              .pushReplacementNamed(TriviaRooms.routeName);
                        } else {
                          setState(() => _currentStep -= 1);
                        }
                      },
                      child: const Text('CANCEL'),
                    ),
                  ],
                );
              },
              currentStep: _currentStep,
              //onStepContinue:
              //onStepCancel:
              steps: [
                Step(
                  title: Text('Quiz Details'),
                  isActive: _currentStep == 0,
                  content: Form(
                    key: _roomFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _nameController,
                          maxLength: 50,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLength: 100,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text('Exercise Time (in seconds)'),
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
                        SizedBox(
                          height: 16,
                        ),
                        Text('Rest Time (in seconds)'),
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
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isPublic,
                              onChanged: (value) {
                                setState(() {
                                  _isPublic = value!;
                                });
                              },
                            ),
                            Text('Public Room'),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        if (!_isPublic)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   _password = value!;
                            // },
                          ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text('Questions Details'),
                  isActive: _currentStep == 1,
                  content: SingleChildScrollView(
                    child: Form(
                      key: _questionsFormKey,
                      child: Column(
                        children: [
                          ..._buildQuizQuestionFields(),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (_quizQuestions.length < 10)
                                ElevatedButton(
                                  onPressed: () => setState(
                                      () => _quizQuestions.add(QuizQuestion(
                                            id: '',
                                            // generate unique ID for new question
                                            correctAnswer: '',
                                            incorrectAnswers: ['','',''],
                                            question: '',
                                            difficulty: '',
                                          ))),
                                  child: Text('Add Question'),
                                ),
                              if (_quizQuestions.length > 2)
                                ElevatedButton(
                                  onPressed: () => setState(
                                      () => _quizQuestions.removeLast()),
                                  child: Text('Remove Question'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildQuizQuestionFields() {
    List<List<String>> answers = List.generate(10, (index) => []);
    for (int i = 0; i < 10; i++) {
      if (i < _quizQuestions.length)
        answers[i] = [
          _quizQuestions[i].correctAnswer,
          ..._quizQuestions[i].incorrectAnswers
        ];
    }

    return List.generate(
      _quizQuestions.length,
      (index) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${index + 1}'),
            SizedBox(height: 8),
            TextFormField(
              controller: TextEditingController(
                  text: _quizQuestions[index].question),
              maxLength: 190,
              validator: (value) {
                if (value == null || value == '') {
                  return "Enter the question";
                } else if (!value!.endsWith("?")) {
                  return "Question must end with question mark";
                }
              },
              onSaved: (value) => setState(() => _quizQuestions[index] =
                  _quizQuestions[index].copyWith(question: value)),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                labelText: 'Question',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: TextEditingController(
                  text: _quizQuestions.length > index
                      ? _quizQuestions[index].correctAnswer
                      : ''),
              maxLength: 55,
              validator: (value) {
                if (value == null) {
                  return "Enter the correct answers";
                }
                answers[index] = [value];
              },
              onSaved: (value) => setState(() => _quizQuestions[index] =
                  _quizQuestions[index].copyWith(correctAnswer: value)),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                labelText: 'Correct Answer',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: TextEditingController(
                  text: _quizQuestions[index].incorrectAnswers[0]),
              maxLength: 55,
              validator: (value) {
                if (value == null || value == '') {
                  return "Enter the incorrect answers";
                } else if (answers[index].contains(value)) {
                  return "all the answers should be different";
                } else {
                  answers[index].add(value);
                }
              },
              onSaved: (value) => setState(() {
                _quizQuestions[index].incorrectAnswers[0] = value!;
              }),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                labelText: 'First Incorrect Answers',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(
                  text: _quizQuestions[index].incorrectAnswers[1]),
              maxLength: 55,
              validator: (value) {
                if (value == null || value == '') {
                  return "Enter the incorrect answers";
                } else if (answers[index].contains(value)) {
                  return "all the answers should be different";
                } else {
                  answers[index].add(value);
                }
              },
              onSaved: (value) => setState(() {
                _quizQuestions[index].incorrectAnswers[1] = value!;
              }),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                labelText: 'Second Incorrect Answers',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(
                  text:  _quizQuestions[index].incorrectAnswers[2]),
              maxLength: 55,
              validator: (value) {
                if (value == null || value == '') {
                  return "Enter the incorrect answers";
                } else if (answers[index].contains(value)) {
                  return "all the answers should be different";
                } else {
                  answers[index].add(value);
                }
              },
              onSaved: (value) => setState(() {
                _quizQuestions[index].incorrectAnswers[2] = value!;
              }),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                labelText: 'Third Incorrect Answers',
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
