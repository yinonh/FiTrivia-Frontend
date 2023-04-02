import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:camera/camera.dart';
import 'Screens/camera_screen.dart';
import 'Screens/no_camera_screen.dart';
import 'Screens/splash_screen.dart';

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
      theme: FlexThemeData.light(
        scheme: FlexScheme.aquaBlue,
        textTheme: text_theme,
      ),
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
            final back_camera = snapshot.data?[1];
            if (back_camera != null) {
              return CameraScreen(back_camera);
            } else {
              return NoCameraScreen();
            }
          }
        },
      ),
    );
  }
}
