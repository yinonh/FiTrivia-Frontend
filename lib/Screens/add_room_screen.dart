import 'package:flutter/material.dart';

import '../Models/question.dart';

class AddRoom extends StatefulWidget {
  static const routeName = '/add_room';
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  int _currentStep = 0;
  final GlobalKey<FormState> _questionsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _roomFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<QuizQuestion> _quizQuestions = List.generate(
      2,
      (index) => QuizQuestion(
            id: UniqueKey().toString(),
            correctAnswer: '',
            incorrectAnswers: ['', '', ''],
            question: '',
            difficulty: '',
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Input Screen'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_roomFormKey.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else {
            if (_questionsFormKey.currentState!.validate())
              _questionsFormKey.currentState!.save();
            print(_quizQuestions);
            // setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep == 0) {
            // TODO: navigate back to previous screen
          } else {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: Text('Quiz Details'),
            isActive: _currentStep == 0,
            content: Form(
              key: _roomFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Please enter a name for the quiz'
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Please enter a description for the quiz'
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: Text('Quiz Questions'),
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
                            onPressed: () =>
                                setState(() => _quizQuestions.add(QuizQuestion(
                                      id: UniqueKey()
                                          .toString(), // generate unique ID for new question
                                      correctAnswer: '',
                                      incorrectAnswers: [],
                                      question: '',
                                      difficulty: '',
                                    ))),
                            child: Text('Add Question'),
                          ),
                        if (_quizQuestions.length > 2)
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => _quizQuestions.removeLast()),
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
              validator: (value) {
                if (value == null || value == '') {
                  return "Enter the question";
                } else if (!value!.endsWith("?")) {
                  return "Question have to ends with ?";
                }
              },
              onSaved: (value) => setState(() => _quizQuestions[index] =
                  _quizQuestions[index].copyWith(question: value)),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Question',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              onSaved: (value) => setState(() => _quizQuestions[index] =
                  _quizQuestions[index].copyWith(correctAnswer: value)),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correct Answer',
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return "Enter the incorrect answers";
                }
              },
              onSaved: (value) => setState(() => _quizQuestions[index] =
                  _quizQuestions[index]
                      .copyWith(incorrectAnswers: value!.split(','))),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Incorrect Answers (comma-separated)',
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
