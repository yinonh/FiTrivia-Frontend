import 'package:flutter/material.dart';
import '../Widgets/bottom_buttons.dart';

import '../l10n/app_localizations.dart';
import '../models/question.dart';

class NoCameraScreen extends StatefulWidget {
  static const routeName = "/no_camera_screen";

  @override
  State<NoCameraScreen> createState() => _NoCameraScreenState();
}

class _NoCameraScreenState extends State<NoCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('No Camera'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context).translate('Camera not found'),
        ),
      ),
    );
  }
}
