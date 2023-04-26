import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fitrivia/Screens/auth_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:camera/camera.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'Screens/camera_screen.dart';
import 'Screens/previous_screen.dart';
import 'Screens/no_camera_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/result_screen.dart';
import 'Screens/trivia_rooms.dart';
import 'Screens/wheel.dart';
import 'Screens/room_detail_screen.dart';
import '../models/question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const TextTheme text_theme = TextTheme(
      displayLarge: TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    );
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == CameraScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;

          final cameraController = args['controller'] as CameraController;
          final quizQuestions = args['questions'] as List<QuizQuestion>;

          return MaterialPageRoute(builder: (context) {
            return CameraScreen(
              controller: cameraController,
              questions: quizQuestions,
            );
          });
        }
        if (settings.name == ResultScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          final responseList = args['response_list'] as List<List<String>>;
          final exDict = args['ex_dict'] as Map<String, int>;
          final correctAnsIndex = args['correct_ans_index'] as List<int>;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(builder: (context) {
            return ResultScreen(
              result: responseList,
              exDict: exDict,
              correctAnsIndex: correctAnsIndex,
            );
          });
        }
      },
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        PreviousScreen.routeName: (context) => PreviousScreen(),
        NoCameraScreen.routeName: (context) => NoCameraScreen(),
        TriviaRooms.routeName:(context) => TriviaRooms(),
        RoomDetails.routeName:(context) => RoomDetails(),
      },
      theme: FlexThemeData.light(
          scheme: FlexScheme.aquaBlue,
          textTheme: text_theme,
          scaffoldBackground: Colors.blueGrey[100]),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.bigStone,
        textTheme: text_theme,
      ),
      themeMode: ThemeMode.system,
      home: AnimatedSplashScreen(
        backgroundColor: (Colors.blueGrey[100])!,
        splash: Center(
          child: Image.asset(
            "assets\\logo.png",
          ),
        ),
        nextScreen: AuthScreen(),
      ),
    );
  }
}
