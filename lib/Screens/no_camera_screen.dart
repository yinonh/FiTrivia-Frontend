import 'package:flutter/material.dart';
import '../Widgets/bottom_buttons.dart';

import '../models/make_request.dart';
import '../models/question.dart';

class NoCameraScreen extends StatefulWidget {
  @override
  State<NoCameraScreen> createState() => _NoCameraScreenState();
}

class _NoCameraScreenState extends State<NoCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Camera'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("camera not found"),
      ),
    );
  }
}
