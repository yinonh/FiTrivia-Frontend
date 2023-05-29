import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Screens/trivia_rooms.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash_screen';
  final String nextScreen;

  const SplashScreen({required this.nextScreen, Key? key}) : super(key: key);

  void startMusic(BuildContext context) {
    // context.read<MusicProvider>().startBgMusic();
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 200,
            ),
            SizedBox(height: 25),
            Container(
              height: 50,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  startMusic(context);
                },
                child: Text(AppLocalizations.of(context)
                    .translate('start')), //Text("START"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
