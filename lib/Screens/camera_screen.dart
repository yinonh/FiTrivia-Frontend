import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../Widgets/rest_popup.dart';
import '../Widgets/bottom_buttons.dart';
import '../models/question.dart';
import '../Screens/result_screen.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera_screen';
  CameraController controller;
  List<QuizQuestion> questions;

  CameraScreen({required this.controller, required this.questions, Key? key})
      : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<XFile> _capturedImages = [];
  int index = 0;
  int numOdQuestions = 2;
  bool _isCapturing = false;
  int countDownTime = 5;
  int restTime = 5;
  Stream<int>? countDownStream;
  List<String> currentEx = [];
  List<List<String>> responseList = [];
  late AnswerButtons ansButtons;
  Map<String, int> exDict = {
    'jumping jacks': 0,
    'squat': 1,
    'stand': 2,
    'side stretch': 3,
    'arm circles': 0,
    'high knees': 1
  };
  late List<String> currentQuestonList;
  List<int> correctAnsIndex = [];
  int lastPressedIndex = -1;
  bool done = false;

  @override
  void initState() {
    super.initState();
    currentQuestonList = _shuffleAnswers();
    update_buttons();
    _startTimer(context);
  }

  void ans_index(int score) {
    correctAnsIndex.add(score);
  }

  List<String> _shuffleAnswers() {
    List<String> allStrings = [
      widget.questions[index].correctAnswer,
      ...widget.questions[index].incorrectAnswers
    ];
    int randomSeed = randomHash(widget.questions[index].correctAnswer,
        widget.questions[index].incorrectAnswers);
    Random random = Random(randomSeed);
    List<String> shuffledList = List<String>.from(allStrings);
    for (int i = shuffledList.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      String temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }
    correctAnsIndex
        .add(shuffledList.indexOf(widget.questions[index].correctAnswer));
    return shuffledList;
  }

  int randomHash(String mainString, List<String> stringList) {
    String inputString = mainString + stringList.join();
    return inputString.hashCode;
  }

  void update_buttons() {
    setState(() {
      ansButtons = AnswerButtons(
        correctAnswer: widget.questions[index].correctAnswer,
        allAnswers: currentQuestonList,
        lastPressedIndex: lastPressedIndex,
        done: done,
      );
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void next_question() {
    setState(() {
      if (index + 1 < numOdQuestions) {
        index++;
        currentQuestonList = _shuffleAnswers();
      }
    });
    update_buttons();
  }

  int getMostFrequentExerciseValue() {
    Map<int, int> freqDict = {}; // Frequency dictionary
    int mostFrequentValue = 0; // Initialize to 0

    // Count the frequency of each exercise value
    for (String ex in currentEx) {
      int? value = exDict[ex];
      freqDict[value ?? 0] =
          (freqDict[value ?? 0] ?? 0) + 1; // Increment the frequency count
    }

    // Find the most frequent exercise value
    int maxFreq = 0;
    for (int value in freqDict.keys) {
      int freq = freqDict[value]!;
      if (freq > maxFreq) {
        maxFreq = freq;
        mostFrequentValue = value;
      }
    }

    return mostFrequentValue;
  }

  Future<void> _startTimer(BuildContext context) async {
    for (int i = 0; i < numOdQuestions; i++) {
      final repeatingTimer =
          Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (widget.controller != null &&
            widget.controller.value.isInitialized) {
          _captureFrame();
        }
      });

      countDownStream = Stream<int>.periodic(Duration(seconds: 1), (i) {
        update_buttons();
        return countDownTime - i - 1;
      }).take(countDownTime);

      Timer(Duration(seconds: countDownTime), () {
        repeatingTimer.cancel();
      });
      Timer(Duration(seconds: countDownTime - 2), () {
        setState(() {
          done = true;
        });
        update_buttons();
      });

      await Future.delayed(Duration(seconds: restTime));
      showDialog(
        context: context,
        builder: (BuildContext cntx) => CustomProgressDialog(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: restTime,
        ),
        barrierDismissible: false,
      );

      await Future.delayed(Duration(seconds: restTime, milliseconds: 50));

      this.lastPressedIndex = -1;
      this.done = false;
      next_question();
      responseList.add([...currentEx]);
      currentEx.clear();
      print(correctAnsIndex);
    }
    Map<String, dynamic> args = {
      "response_list": responseList,
      "ex_dict": exDict,
      "correct_ans_index": correctAnsIndex
    };
    Navigator.pushReplacementNamed(context, ResultScreen.routeName,
        arguments: args);
  }

  Future<void> _sendImages() async {
    if (_capturedImages.length == 10) {
      List<http.MultipartFile> imageFiles = [];
      for (var image in _capturedImages) {
        var bytes = await image.readAsBytes();
        var fileName = path.basename(image.path);
        var file = http.MultipartFile.fromBytes('images', bytes,
            filename: fileName, contentType: MediaType('image', 'jpeg'));
        imageFiles.add(file);
      }
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:8000/images/'));
      request.files.addAll(imageFiles);
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          // Success
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = jsonDecode(responseBody);
          print(jsonResponse);
          currentEx.add(jsonResponse['message']);
          lastPressedIndex = getMostFrequentExerciseValue();
        } else {
          // Error
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        // Exception
        print('Exception: $e');
      }
    }
  }

  void _captureFrame() async {
    if (_isCapturing) {
      return;
    }
    try {
      _isCapturing = true;
      XFile imageFile = await widget.controller.takePicture();
      if (_capturedImages.length < 10) {
        _capturedImages.add(imageFile);
      }
      if (_capturedImages.length == 10) {
        await _sendImages();
        _capturedImages.clear();
      }
    } catch (e) {
      print('Error capturing frame: $e');
    } finally {
      _isCapturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: countDownStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Time Left: ${snapshot.data} s');
            } else {
              return Text('Time Left: 0 s');
            }
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.5,
        //width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  (MediaQuery.of(context).size.height <
                          MediaQuery.of(context).size.width
                      ? 0.5
                      : 0.4),
              child: Hero(
                tag: 'camera_preview',
                child: AspectRatio(
                  aspectRatio: MediaQuery.of(context).size.height <
                          MediaQuery.of(context).size.width
                      ? 10 / 6
                      : 4 / 6,
                  child: CameraPreview(widget.controller),
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  0.1,
              child: Center(
                child: Text(
                  widget.questions[index].question,
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).viewPadding.top) *
                    (MediaQuery.of(context).size.height <
                            MediaQuery.of(context).size.width
                        ? 0.4
                        : 0.5),
                child: ansButtons)
          ],
        ),
      ),
    );
  }
}
