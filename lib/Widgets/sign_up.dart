import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final VoidCallback changeMode;

  const SignUp({required this.changeMode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Register',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 32),
        TextFormField(
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            labelText: 'User Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/previus_screen');
          },
          child: Text('Sign Up'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: changeMode,
              child: const Text(
                'Sign In Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
