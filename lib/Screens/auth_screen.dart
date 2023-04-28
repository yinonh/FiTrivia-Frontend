import 'package:flutter/material.dart';

import '../Widgets/log_in.dart';
import '../Widgets/sign_up.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth_screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool loginMode = true;
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<Size>(
      begin: Size(500, 420),
      end: Size(500, 590),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _changeMode() {
    if (loginMode) {
      loginMode = false;
      _controller.forward();
    } else {
      loginMode = true;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGrid(),
          Center(
            child: AnimatedBuilder(
              animation: _heightAnimation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  height: _heightAnimation.value.height,
                  width: 500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.white54,
                        )
                      ]),
                  child: SingleChildScrollView(
                    child: loginMode
                        ? LogIn(changeMode: _changeMode)
                        : SignUp(changeMode: _changeMode),
                  ),
                );
              },
            ),
          )
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
