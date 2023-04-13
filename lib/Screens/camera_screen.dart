import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../Widgets/bottom_buttons.dart';
import '../models/make_request.dart';
import '../models/question.dart';

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

  @override
  void initState() {
    super.initState();

    _futureQuestions = fetchQuestions();

    _futureQuestions?.then((questions) {
      questionsLength = questions.length;
    });

    _startTimer();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void next_question() {
    setState(() {
      if (index + 1 < questionsLength) index++;
    });
  }

  void _startTimer() {
    final repeatingTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (widget.controller != null && widget.controller.value.isInitialized) {
        _captureFrame();
      }
    });

    countDownStream = Stream<int>.periodic(Duration(seconds: 1), (i) {
      return count_down_time - i - 1;
    }).take(count_down_time);

    Timer(Duration(seconds: count_down_time + 10), () {
      repeatingTimer.cancel();
      setState(() {
        timerCounter++;
      });
      if (timerCounter < 5) {
        next_question();
        _startTimer();
      }
    });
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
          print(responseBody);
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
                      return bottom_buttons(
                        correctAnswer: snapshot.data![index].correctAnswer,
                        wrongAnswers: snapshot.data![index].incorrectAnswers,
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
