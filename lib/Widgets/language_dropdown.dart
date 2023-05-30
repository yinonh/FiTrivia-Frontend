import 'package:flutter/material.dart';
import 'package:fitrivia/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Providers/user_provider.dart';

class LanguageDropdown extends StatefulWidget {
  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String _selectedLanguage = 'en';
  UserProvider _userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    _getUserLanguage();
  }

  Future<void> _getUserLanguage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? languageCode = await _userProvider.getUserLanguage(user.uid);
      if (languageCode != null) {
        setState(() {
          _selectedLanguage = languageCode;
        });
      }
    }
  }

  void _onLanguageChanged(String? languageCode) async {
    if (languageCode != null) {
      setState(() {
        _selectedLanguage = languageCode;
      });

      // Update the app's locale based on the selected language
      Locale newLocale;
      switch (languageCode) {
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
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        FitriviaApp.setLocale(context, newLocale);
      });

      // Update the user's language in Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _userProvider.updateUserLanguage(user.uid, languageCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: DropdownButton<String>(
        value: _selectedLanguage,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 1,
        ),
        onChanged: _onLanguageChanged,
        items: <String>['en', 'he'].map((String languageCode) {
          return DropdownMenuItem<String>(
            value: languageCode,
            child: Container(
              height: 300,
              width: 200, // Specify a fixed width for the container
              child: ListTile(
                leading: _buildFlagIcon(languageCode),
                title: Text(_getLanguageName(languageCode)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFlagIcon(String languageCode) {
    String flagAsset;
    switch (languageCode) {
      case 'en':
        flagAsset = 'assets/english.png';
        break;
      case 'he':
        flagAsset = 'assets/israel.png';
        break;
      default:
        flagAsset = '';
    }
    return SizedBox(
      width: 35,
      height: 35,
      child: Image.asset(
        flagAsset,
        width: 35,
        height: 35,
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'he':
        return 'עברית';
      default:
        return '';
    }
  }
}
