import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../Screens/trivia_rooms.dart';
import '../Providers/music_provider.dart';

class ForgotPassword extends StatelessWidget {
  final void Function(String) changeMode;

  ForgotPassword({Key? key, required this.changeMode}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Declare variables to hold the email and password values
  String? _email;

  @override
  Widget build(BuildContext context) {
    Future resetPassword() async{
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!);
        showDialog(
          context: context,
          builder: (ctx){
            return AlertDialog(
              content: const Text('Reset password instructions sent successfully, check your mail inbox..'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch(e){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Forgot Password',
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
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Save the form's state
                _formKey.currentState!.save();
                resetPassword();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Reset Password'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => changeMode('login'),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => changeMode('signup'),
                child: const Text(
                  'Register',
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
