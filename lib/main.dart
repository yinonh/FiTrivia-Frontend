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
            final arg = settings.arguments as CameraController;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(builder: (context) {
              return CameraScreen(
                controller: arg,
              );
            });
          }
          else if(settings.name == ResultScreen.routeName){
            final arg = settings.arguments as  List<List<String>>;

            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(builder: (context) {
              return ResultScreen(
                result: arg,
              );
            });
          }
        },
        routes: {
          '/countdown_screen': (context) => SplashScreen(),
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
        home: FutureBuilder<List<CameraDescription>>(
          future: availableCameras(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else if (snapshot.hasError || snapshot.data == null) {
              return NoCameraScreen();
            } else {
              final back_camera = snapshot.data?.last;
              if (back_camera != null) {
                return PreviousScreen(back_camera);
              } else {
                return NoCameraScreen();
              }
            }
          },
        ));
  }
}
