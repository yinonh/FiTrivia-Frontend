import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'Screens/camera_screen.dart';
import 'Screens/no_camera_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    runApp(MyApp(firstCamera));
  } catch (CameraException) {
    runApp(NoCameraApp());
  }
}
