import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Screens/no_camera_screen.dart';
import '../Screens/camera_screen.dart';
import '../Models/trivia_room.dart';
import '../Providers/music_provider.dart';

class PreviousScreen extends StatefulWidget {
  static const routeName = '/previous_screen';
  final TriviaRoom room;

  const PreviousScreen({required this.room, Key? key}) : super(key: key);

  @override
  _PreviousScreenState createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen> {
  late bool isControllerInitialized;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool pressed = false;
  int _countdownValue = 6;
  Timer? _countdownTimer;
  bool cameraAvailable = true;
  late MusicProvider _musicProvider;

  @override
  void initState() {
    super.initState();
    isControllerInitialized = false;
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    availableCameras().then((camerasList) {
      if (camerasList.isEmpty) {
        setState(() {
          cameraAvailable = false;
        });
      } else {
        final cameras = <CameraLensDirection, CameraDescription>{};
        for (final cameraDescription in camerasList) {
          if (!cameras.containsKey(cameraDescription.lensDirection)) {
            cameras[cameraDescription.lensDirection] = cameraDescription;
          }
        }
        CameraDescription? backCamera;
        if (cameras.length == 1) {
          backCamera = cameras.values.last;
        } else if (cameras.length > 1) {
          backCamera = cameras[CameraLensDirection.front] ??
              cameras[CameraLensDirection.back];
        }
        if (backCamera != null) {
          _controller = CameraController(
            backCamera,
            ResolutionPreset.high,
          );
          _initializeControllerFuture = _controller.initialize().then((_) {
            setState(() {
              isControllerInitialized = true;
            });
          });
        } else {
          setState(() {
            cameraAvailable = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    //TODO: Dispose only if not process to camera screen.
    _countdownTimer?.cancel();
    _musicProvider.stopClockMusic();
    super.dispose();
  }

  void startCountdown() async {
    // clockPlayer.play(clock);
    // Start the countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_countdownValue == 1) {
        // Wait for the future to complete and get the result
        // List<QuizQuestion> questions =
        //     Provider.of<TriviaRoomProvider>(context, listen: false)
        //         .getQuestionsForRoom(widget.room.id); //await _futureQuestions;
        // Navigate to the CameraScreen when the countdown is finished
        final Map<String, dynamic> arguments = {
          'controller': _controller,
          'questions': widget.room,
        };
        _musicProvider.stopClockMusic();
        Navigator.of(context)
            .popUntil((route) => route.isFirst); // clean the Navigator
        Navigator.pushReplacementNamed(context, CameraScreen.routeName,
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
        child:
            Text(AppLocalizations.of(context).translate('No camera available')),
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _musicProvider.startBgMusic(FirebaseAuth.instance.currentUser!.uid);
            Navigator.pop(context);
          },
        ),
      ),
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
                  onPressed: !pressed && isControllerInitialized
                      ? () {
                          _musicProvider.pauseBgMusic();
                          _musicProvider.startClockMusic();

                          // Start the countdown when the "Ready" button is pressed
                          startCountdown();

                          // Disable the button after it has been pressed
                          setState(() {
                            pressed = true;
                          });
                        }
                      : null,
                  child: Text(
                    (!isControllerInitialized)
                        ? AppLocalizations.of(context).translate('Loading...')
                        : (_countdownValue == 6)
                            ? AppLocalizations.of(context).translate('Ready')
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
