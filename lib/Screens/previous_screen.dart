import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import '../models/make_request.dart';
import '../models/question.dart';

class PreviousScreen extends StatefulWidget {
  static const routeName = '/previous_screen';
  final CameraDescription camera;

  PreviousScreen(this.camera);

  @override
  _PreviousScreenState createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen> {
  late CameraController _controller;
  late Future<List<QuizQuestion>> _futureQuestions;
  late Future<void> _initializeControllerFuture;
  bool pressed = false;
  int _countdownValue = 6;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      // enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
    _futureQuestions = fetchQuestions().whenComplete(() {
      setState(() {
        // Ensure that the state is updated after both the controller and futureQuestions are initialized
        pressed = true;
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() async {
    // Start the countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_countdownValue == 1) {
        // Wait for the future to complete and get the result
        List<QuizQuestion> questions = await _futureQuestions;
        // Navigate to the CameraScreen when the countdown is finished
        final Map<String, dynamic> arguments = {
          'controller': _controller,
          'questions': questions,
        };
        Navigator.pushReplacementNamed(context, '/camera_screen', arguments: arguments);
        timer.cancel();
      } else {
        setState(() {
          // Update the countdown value
          _countdownValue--;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).viewPadding.top) *
                  (MediaQuery.of(context).size.height <
                      MediaQuery.of(context).size.width
                      ? 0.6
                      : 0.5),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Hero(
                              tag: 'camera_preview',
                              child: AspectRatio(
                                aspectRatio: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                    ? 10 / 6
                                    : 4 / 6,
                                child: CameraPreview(_controller),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: pressed
                    ? () {
                  // Start the countdown when the "Ready" button is pressed
                  startCountdown();
                }
                    : null,
                child: Text(
                  pressed ? '$_countdownValue' : 'Loading...',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
