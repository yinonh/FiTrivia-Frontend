import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'l10n/app_localizations.dart';
import 'Screens/auth_screen.dart';
import 'Screens/camera_screen.dart';
import 'Screens/previous_screen.dart';
import 'Screens/no_camera_screen.dart';
import 'Screens/splash_screen.dart';
import 'Screens/result_screen.dart';
import 'Screens/trivia_rooms.dart';
import 'Screens/wheel.dart';
import 'Screens/connect_us_screen.dart';
import 'Screens/room_detail_screen.dart';
import 'Screens/add_room_screen.dart';
import 'Screens/edit_room.dart';
import 'Screens/settings_screen.dart';
import 'Models/trivia_room.dart';
import 'Providers/trivia_rooms_provider.dart';
import 'Providers/user_provider.dart';
import 'Providers/music_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MusicProvider()),
        ChangeNotifierProvider(create: (context) => TriviaRoomProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: FitriviaApp(),
    ),
  );
}

class FitriviaApp extends StatefulWidget {
  const FitriviaApp({
    Key? key,
  }) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    final _FitriviaAppState state =
        context.findAncestorStateOfType<_FitriviaAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<FitriviaApp> createState() => _FitriviaAppState();
}

class _FitriviaAppState extends State<FitriviaApp> {
  Locale _locale = const Locale('en', '');
  late String initialScreen;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void setLanguage(User? currentUser) async {
    if (currentUser == null) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    }
    // Retrieve the user's language preference from Firebase
    String? language = await UserProvider().getUserLanguage(currentUser!.uid);

    // Update the app's locale based on the selected language
    Locale newLocale;
    switch (language) {
      case 'en':
        newLocale = const Locale('en', '');
        break;
      case 'he':
        newLocale = const Locale('he', '');
        break;
      default:
        newLocale = const Locale('en', '');
    }

    // Update the app's locale by rebuilding the MaterialApp
    setLocale(newLocale);
  }

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    initialScreen = AuthScreen.routeName;
    if (currentUser != null) {
      setLanguage(currentUser);
      initialScreen = TriviaRooms.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextTheme text_theme = TextTheme(
      displayLarge: TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('he', 'IL'),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == CameraScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;

          final cameraController = args['controller'] as CameraController;
          final triviaRoom = args['questions'] as TriviaRoom;

          return MaterialPageRoute(builder: (context) {
            return CameraScreen(
              controller: cameraController,
              room: triviaRoom,
            );
          });
        } else if (settings.name == ResultScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          final responseList = args['response_list'] as List<List<String>>;
          final exDict = args['ex_dict'] as Map<String, int>;
          final correctAnsIndex = args['correct_ans_index'] as List<int>;
          final room = args['room'] as TriviaRoom;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(builder: (context) {
            return ResultScreen(
              result: responseList,
              exDict: exDict,
              correctAnsIndex: correctAnsIndex,
              room: room,
            );
          });
        } else if (settings.name == RoomDetails.routeName) {
          return MaterialPageRoute(builder: (context) {
            return RoomDetails(
              roomIdentifier: settings.arguments as String,
            );
          });
        } else if (settings.name == PreviousScreen.routeName) {
          return MaterialPageRoute(builder: (context) {
            return PreviousScreen(
              room: settings.arguments as TriviaRoom,
            );
          });
        } else if (settings.name == EditRoom.routeName) {
          return MaterialPageRoute(builder: (context) {
            return EditRoom(
              roomID: settings.arguments as String,
            );
          });
        }
      },
      routes: {
        AuthScreen.routeName: (context) => AuthScreen(),
        NoCameraScreen.routeName: (context) => NoCameraScreen(),
        TriviaRooms.routeName: (context) => TriviaRooms(),
        WheelScreen.routeName: (context) => WheelScreen(),
        ConnectUsPage.routeName: (context) => ConnectUsPage(),
        AddRoom.routeName: (context) => AddRoom(),
        UserDetailsScreen.routeName: (context) => UserDetailsScreen(),
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
      home: SplashScreen(
        nextScreen: initialScreen,
      ),
    );
  }
}
