import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../Screens/trivia_rooms.dart';
import '../Providers/users_provider.dart';

class LogIn extends StatelessWidget {
  final VoidCallback changeMode;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Declare variables to hold the email and password values
  String? _email;
  String? _password;

  LogIn({required this.changeMode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Log In',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!EmailValidator.validate(value)) {
                return "Email invalid";
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 6) {
                return 'Password should be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
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
              if (_formKey.currentState!.validate()) {
                // Save the form's state
                _formKey.currentState!.save();
                if (Provider.of<UsersProvider>(context, listen: false)
                        .getUserByEmailAndPassword(_email!, _password!) !=
                    null) {
                  Navigator.pushReplacementNamed(
                      context, TriviaRooms.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                        'This user is\'t exist',
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              } else {
                Navigator.pushReplacementNamed(context, TriviaRooms.routeName);
              }
            },
            child: Text('Sign In'),
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
                onPressed: this.changeMode,
                child: const Text(
                  'Register Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
