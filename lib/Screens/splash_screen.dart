import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets\\logo.png",
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              child: const LinearProgressIndicator(
                  //value: 5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
