import 'package:fitrivia/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Screens/trivia_rooms.dart';
import '../Providers/music_provider.dart';
import '../Providers/user_provider.dart';

class LogIn extends StatefulWidget {
  final void Function(String) changeMode;

  LogIn({required this.changeMode, Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserProvider _userProvider = UserProvider(); // Initialize UserProvider

  String? _email;
  String? _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('Log in'),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
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
                labelText: AppLocalizations.of(context).translate('Password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      // Save the form's state
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        UserCredential currentUser = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _email!,
                          password: _password!,
                        );
                        final musicProvider = context.read<MusicProvider>();
                        await musicProvider.startBgMusic(currentUser.user!.uid);

                        // Retrieve the user's language preference from Firebase
                        String? language = await _userProvider
                            .getUserLanguage(currentUser.user!.uid);

                        // Update the app's locale based on the selected language
                        Locale newLocale;
                        switch (language) {
                          case 'en':
                            newLocale = const Locale('en', '');
                            break;
                          case 'he':
                            newLocale = const Locale('he', '');
                            break;
                          default:
                            newLocale = const Locale('en', '');
                        }

                        // Update the app's locale by rebuilding the MaterialApp
                        FitriviaApp.setLocale(context, newLocale);

                        Navigator.pushReplacementNamed(
                          context,
                          TriviaRooms.routeName,
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                              AppLocalizations.of(context)
                                  .translate('Failed to sign in'),
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
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
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(AppLocalizations.of(context).translate('Log in')),
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
                onPressed: () => widget.changeMode('signup'),
                child: Text(
                  AppLocalizations.of(context).translate('Register'),
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
