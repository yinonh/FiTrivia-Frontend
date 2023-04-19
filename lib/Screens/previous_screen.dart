import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import '../Screens/no_camera_screen.dart';
import '../models/make_request.dart';
import '../models/question.dart';

class PreviousScreen extends StatefulWidget {
  static const routeName = '/previous_screen';

  @override
  _PreviousScreenState createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen> {
  late bool isControllerInitialized;
  late CameraController _controller;
  late Future<List<QuizQuestion>> _futureQuestions;
  late Future<void> _initializeControllerFuture;
  bool pressed = false;
  int _countdownValue = 6;
  Timer? _countdownTimer;
  bool cameraAvailable = true;

  @override
  void initState() {
    super.initState();
    isControllerInitialized = false;
    _futureQuestions = fetchQuestions().whenComplete(() {
      setState(() {
        pressed = true;
      });
    });
    availableCameras().then((cameras) {
      if (cameras.isEmpty) {
        setState(() {
          cameraAvailable = false;
        });
      } else {
        final backCamera = cameras.last;
        _controller = CameraController(
          backCamera,
          ResolutionPreset.high,
          // enableAudio: false,
        );
        _initializeControllerFuture = _controller.initialize().then((_) {
          setState(() {
            isControllerInitialized = true;
          });
        });
      }
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
        Navigator.pushReplacementNamed(context, '/camera_screen',
            arguments: arguments);
        timer.cancel();
      } else {
        setState(() {
          // Update the countdown value
          _countdownValue--;
        });
      }
    });
  }

  Widget _buildCameraPreview() {
    if (!cameraAvailable) {
      return Center(
        child: Text('No camera available'),
      );
    } else if (!isControllerInitialized) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
      );
    } else {
      return Container(
        height: (MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).viewPadding.top) *
            (MediaQuery.of(context).size.height <
                    MediaQuery.of(context).size.width
                ? 0.6
                : 0.5),
        child: Center(
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
        ),
      );
    }
  }

  Widget camera_preview(Widget content) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 200, // Set the width to the maximum available width
                height:
                    60.0, // Set the height to 60.0 (you can adjust this as needed)
                child: ElevatedButton(
                  onPressed: pressed && isControllerInitialized
                      ? () {
                          // Start the countdown when the "Ready" button is pressed
                          startCountdown();

                          // Disable the button after it has been pressed
                          setState(() {
                            pressed = false;
                          });
                        }
                      : null,
                  child: Text(
                    (!isControllerInitialized)
                        ? 'Loading...'
                        : (_countdownValue == 6)
                            ? 'Ready'
                            : '$_countdownValue',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        // Set a different background color for the disabled state
                        return Colors.grey.withOpacity(0.5);
                      }
                      // Return the default background color for the enabled state
                      return Theme.of(context).colorScheme.primary;
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameras(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CameraDescription>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return NoCameraScreen();
          } else {
            return camera_preview(_buildCameraPreview());
          }
        } else if (snapshot.hasError) {
          return NoCameraScreen();
        } else {
          return camera_preview(CircularProgressIndicator());
        }
      },
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           FutureBuilder<List<CameraDescription>>(
//               future: availableCameras(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<CameraDescription>> snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.isEmpty) {
//                     return Text("no camera");
//                   } else {
//                     return _buildCameraPreview();
//                   }
//                 } else if (snapshot.hasError) {
//                   return Text("no camera");
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               }),
//           const SizedBox(height: 40),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SizedBox(
//               width: 200, // Set the width to the maximum available width
//               height:
//               60.0, // Set the height to 60.0 (you can adjust this as needed)
//               child: ElevatedButton(
//                 onPressed: pressed && isControllerInitialized
//                     ? () {
//                   // Start the countdown when the "Ready" button is pressed
//                   startCountdown();
//
//                   // Disable the button after it has been pressed
//                   setState(() {
//                     pressed = false;
//                   });
//                 }
//                     : null,
//                 child: Text(
//                   (!isControllerInitialized)
//                       ? 'Loading...'
//                       : (_countdownValue == 6)
//                       ? 'Ready'
//                       : '$_countdownValue',
//                   style: TextStyle(fontSize: 20.0),
//                 ),
//                 style: ButtonStyle(
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50.0),
//                     ),
//                   ),
//                   backgroundColor:
//                   MaterialStateProperty.resolveWith<Color>((states) {
//                     if (states.contains(MaterialState.disabled)) {
//                       // Set a different background color for the disabled state
//                       return Colors.grey.withOpacity(0.5);
//                     }
//                     // Return the default background color for the enabled state
//                     return Theme.of(context).colorScheme.primary;
//                   }),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
