import 'package:flutter/material.dart';

import 'package:fitrivia/main.dart';

class LanguageDropdown extends StatefulWidget {
  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String _selectedLanguage = 'English';

  void _onLanguageChanged(String? language) {
    if (language != null) {
      setState(() {
        _selectedLanguage = language;
      });

      // Update the app's locale based on the selected language
      Locale newLocale;
      switch (language) {
        case 'English':
          newLocale = const Locale('en', '');
          break;
        case 'עברית':
          newLocale = const Locale('he', '');
          break;
        default:
          newLocale = const Locale('en', '');
      }

      // Update the app's locale by rebuilding the MaterialApp
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        FitriviaApp.setLocale(context, newLocale);
      });
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
        items: <String>['English', 'עברית'].map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Container(
              height: 300,
              width: 200, // Specify a fixed width for the container
              child: ListTile(
                leading: _buildFlagIcon(language),
                title: Text(language),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFlagIcon(String language) {
    String flagAsset;
    switch (language) {
      case 'English':
        flagAsset = 'assets/english.png';
        break;
      case 'עברית':
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
}
