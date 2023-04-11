import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class PreviousScreen extends StatefulWidget {
  static const routeName = '/previous_screen';
  final CameraDescription camera;

  PreviousScreen(this.camera);

  @override
  _PreviousScreenState createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen> {
  late CameraController _controller;
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
      // imageFormatGroup: ImageFormatGroup.yuv420,
      // enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
    //_startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    // Start the countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownValue == 1) {
        // Navigate to the CameraScreen when the countdown is finished
        Navigator.pushReplacementNamed(context, '/camera_screen',
            arguments: _controller);
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
                onPressed: () {
                  pressed = true;
                  // Start the countdown when the "Ready" button is pressed
                  startCountdown();
                },
                child: Text(
                  pressed ? '$_countdownValue' : 'Ready!',
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
