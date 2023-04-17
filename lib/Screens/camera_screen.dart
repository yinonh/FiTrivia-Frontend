import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../Widgets/rest_popup.dart';
import '../Widgets/bottom_buttons.dart';
import '../models/make_request.dart';
import '../models/question.dart';
import '../Screens/result_screen.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera_screen';
  CameraController controller;

  CameraScreen({required this.controller, Key? key}) : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Future<List<QuizQuestion>>? _futureQuestions;
  List<XFile> _capturedImages = [];
  int questionsLength = 0;
  int index = 0;
  bool _isCapturing = false;
  int count_down_time = 10;
  Stream<int>? countDownStream;
  int timerCounter = 0;
  List<String> current_ex = [];
  List<List<String>> response_list = [];
  late bottom_buttons ans_buttons;
  Map<String, int> ex_dict = {'jumping jacks': 0, 'squat': 1, 'stand': 2, 'side stretch': 3, 'arm circles': 4, 'high knees': 5};

  @override
  void initState() {
    super.initState();

    _futureQuestions = fetchQuestions();

    _futureQuestions?.then((questions) {
      questionsLength = questions.length;
    });

    _startTimer(context);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    //ans_buttons.dispose();
    super.dispose();
  }

  void next_question() {
    setState(() {
      if (index + 1 < questionsLength) index++;
    });
  }

  int getMostFrequentExerciseValue() {
    Map<int, int> freqDict = {}; // Frequency dictionary
    int mostFrequentValue = 0; // Initialize to 0

    // Count the frequency of each exercise value
    for (String ex in current_ex) {
      int? value = ex_dict[ex];
      freqDict[value ?? 0] = (freqDict[value ?? 0] ?? 0) + 1; // Increment the frequency count
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
    for (int i = 0; i < 2; i++) {
      Timer(Duration(seconds: 1), () {
          ans_buttons.lastPressedIndex = i;
          print(ans_buttons.done);
      });
      final repeatingTimer =
          Timer.periodic(Duration(milliseconds: count_down_time), (timer) {
        if (widget.controller != null &&
            widget.controller.value.isInitialized) {
          _captureFrame();
        }
      });

      countDownStream = Stream<int>.periodic(Duration(seconds: 1), (i) {
        return count_down_time - i - 1;
      }).take(count_down_time);

      Timer(Duration(seconds: 10), () {
        repeatingTimer.cancel();
      });
      Timer(Duration(seconds: 8), () {
        ans_buttons.done = true;
      });

      await Future.delayed(Duration(seconds: 10));
        showDialog(
          context: context,
          builder: (BuildContext cntx) =>
              CustomProgressDialog(
                tween: Tween<double>(begin: 0.0, end: 1.0),
              ),
          barrierDismissible: false,
        );

        // Wait 10 seconds before closing the dialog box
        await Future.delayed(Duration(seconds: 10, milliseconds: 10));

      next_question();
      response_list.add([...current_ex]);
      current_ex.clear();
    }
    Navigator.pushReplacementNamed(context, ResultScreen.routeName, arguments: response_list);
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
        print(response.statusCode);
        if (response.statusCode == 200) {
          // Success
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = jsonDecode(responseBody);
          current_ex.add(jsonResponse['message']);
          ans_buttons.lastPressedIndex = getMostFrequentExerciseValue();

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
                      ? 0.6
                      : 0.5),
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
                child: FutureBuilder<List<QuizQuestion>>(
                    future: _futureQuestions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data');
                      } else {
                        return Text(
                          snapshot.data![index].question,
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center,
                        );
                      }
                    }),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  (MediaQuery.of(context).size.height <
                          MediaQuery.of(context).size.width
                      ? 0.3
                      : 0.4),
              child: FutureBuilder<List<QuizQuestion>>(
                  future: _futureQuestions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data');
                    } else {
                      ans_buttons = bottom_buttons(
                        correctAnswer: snapshot.data![index].correctAnswer,
                        wrongAnswers: snapshot.data![index].incorrectAnswers,
                      );
                      return ans_buttons;
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
