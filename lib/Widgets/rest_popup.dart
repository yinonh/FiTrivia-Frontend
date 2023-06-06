import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RestDialog extends StatefulWidget {
  final Tween<double> tween;
  final int duration;
  final String question;
  const RestDialog(
      {Key? key,
      required this.tween,
      required this.duration,
      required this.question})
      : super(key: key);

  @override
  State<RestDialog> createState() => _RestDialogState();
}

class _RestDialogState extends State<RestDialog> {
  bool last5sec = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.duration - 5), () {
      setState(() {
        last5sec = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: AlertDialog(
        content: Container(
          width: 350.0,
          height: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              last5sec && widget.question != ""
                  ? Center(
                      child: AutoSizeText(
                        widget.question,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                        maxLines: 4,
                      ),
                    )
                  : Image.asset(
                      'assets/rest.gif',
                      width: 250,
                      height: 250,
                    ),
              SizedBox(height: 30),
              TweenAnimationBuilder(
                tween: widget.tween,
                builder: (BuildContext context, double value, Widget? child) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        color: Colors.deepOrangeAccent,
                      ),
                    ],
                  );
                },
                duration: Duration(seconds: widget.duration),
                onEnd: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
