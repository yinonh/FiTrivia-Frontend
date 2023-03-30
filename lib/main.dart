import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:camera/camera.dart';
import 'Screens/camera_screen.dart';
import 'Screens/no_camera_screen.dart';
import 'Screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Colors.grey,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        errorColor: Colors.deepOrangeAccent,

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else if (snapshot.hasError || snapshot.data == null) {
            return NoCameraScreen();
          } else {
            final firstCamera = snapshot.data?.first;
            if (firstCamera != null) {
              return CameraScreen(firstCamera);
            } else {
              return NoCameraScreen();
            }
          }
        },
      ),
    );
  }
}
