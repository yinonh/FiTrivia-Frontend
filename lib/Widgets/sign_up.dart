import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';
import '../Providers/users_provider.dart';
import '../Screens/trivia_rooms.dart';

class SignUp extends StatelessWidget {
  final VoidCallback changeMode;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password1;
  String? _password2;
  String? _userName;

  SignUp({required this.changeMode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your user name';
              }
              return null;
            },
            onSaved: (value) {
              _userName = value;
            },
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
              _password1 = value;
              return null;
            },
            onSaved: (value) {
              _password1 = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              labelText: 'Confirm password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              _password2 = value;
              if (_password1 != _password2) {
                return 'Passwords do not match';
              }
              return null;
            },
            onSaved: (value) {
              _password2 = value;
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
                Provider.of<UsersProvider>(context, listen: false).addUser(User(uid: "123", username: _userName!, email: _email!, password: _password2!),);
                Navigator.pushReplacementNamed(context, TriviaRooms.routeName);
              }
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
      ),
    );
  }
}
