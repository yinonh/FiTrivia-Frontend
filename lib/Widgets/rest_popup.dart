import 'package:flutter/material.dart';

class CustomProgressDialog extends StatelessWidget {
  final Tween<double> tween;
  const CustomProgressDialog({Key? key, required this.tween}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: AlertDialog(
        content: SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/rest.gif',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 30),
              TweenAnimationBuilder(
                tween: tween,
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
                duration: Duration(seconds: 10),
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
