import 'package:flutter/material.dart';

import '../Widgets/log_in.dart';
import '../Widgets/sign_up.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool loginMode = true;

  void _changeMode() {
    setState(() {
      loginMode = !loginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGrid(),
          loginMode
              ? LogIn(changeMode: _changeMode)
              : SignUp(changeMode: _changeMode),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff35a0cb),
            Colors.white54,
          ],
        ),
      ),
    );
  }
}
