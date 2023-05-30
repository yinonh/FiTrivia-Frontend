import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Providers/music_provider.dart';
import '../Screens/trivia_rooms.dart';

class SignUp extends StatefulWidget {
  final void Function(String) changeMode;

  SignUp({required this.changeMode, Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password1;
  String? _password2;
  String? _userName;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();
    try {
      final UserCredential currentUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email!, password: _password2!);

      final defaultMusicSettings = {
        'volume': 0.7,
        'gameMusicOn': true,
        'backgroundMusicOn': true,
        'musicType': 'metal',
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.user!.uid)
          .set({
        'userName': _userName!,
        "isAdmin": false,
        'musicSettings': defaultMusicSettings,
        'language': "en"
      });
      final musicProvider = context.read<MusicProvider>();
      await musicProvider.fetchMusicSettings(currentUser.user!.uid);
      Navigator.pushReplacementNamed(context, TriviaRooms.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).translate('Register'),
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
                return AppLocalizations.of(context)
                    .translate('Please enter your user name');
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
              labelText: AppLocalizations.of(context).translate('User Name'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('Please enter your email');
                } else if (!EmailValidator.validate(value)) {
                  return AppLocalizations.of(context)
                      .translate('Email invalid');
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
                labelText: AppLocalizations.of(context).translate('Email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('Please enter your password');
                } else if (value.length < 6) {
                  return AppLocalizations.of(context)
                      .translate('Password should be at least 6 characters');
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
                labelText: AppLocalizations.of(context).translate('Password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('Please confirm your password');
                }
                _password2 = value;
                if (_password1 != _password2) {
                  return AppLocalizations.of(context)
                      .translate('Passwords do not match');
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
                labelText:
                    AppLocalizations.of(context).translate('Confirm password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(AppLocalizations.of(context).translate('Register')),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => widget.changeMode('forgot_password'),
                child: Text(
                  AppLocalizations.of(context).translate('Forgot Password'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => widget.changeMode('login'),
                child: Text(
                  AppLocalizations.of(context).translate('Log in'),
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
