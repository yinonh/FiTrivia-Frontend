import 'package:fitrivia/Widgets/forgot_password.dart';
import 'package:flutter/material.dart';

import '../Widgets/log_in.dart';
import '../Widgets/sign_up.dart';
import '../Widgets/forgot_password.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  String screenMode = 'login';
  late AnimationController _controller;
  late Animation<Size> _animation;
  Size _animationStartValue = Size(500, 420);
  Size _animationEndValue = Size(500, 600);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Size>(
      begin: _animationStartValue,
      end: _animationEndValue,
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

  void _changeMode(String state) {
    if (state == 'signup') {
      screenMode = 'signup';
      _animation = Tween<Size>(
        begin: _animation.value,
        end: Size(500, 600),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );
      _controller.forward(from: 0.0);
    } else if (state == 'forgot_password') {
      screenMode = 'forgot_password';
      _animation = Tween<Size>(
        begin: _animation.value,
        end: Size(350, 350),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );
      _controller.forward(from: 0.0);
    } else if (state == 'login') {
      screenMode = 'login';
      _animation = Tween<Size>(
        begin: _animation.value,
        end: Size(500, 420),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );
      _controller.forward(from: 0.0);
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
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  height: _animation.value.height,
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
                    child: screenMode == 'login'
                        ? LogIn(changeMode: _changeMode)
                        : screenMode == 'signup'
                            ? SignUp(changeMode: _changeMode)
                            : ForgotPassword(changeMode: _changeMode),
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
