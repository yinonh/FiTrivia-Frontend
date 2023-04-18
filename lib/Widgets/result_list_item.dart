import 'package:flutter/material.dart';
import '../Widgets/chart.dart';

class ListItem extends StatelessWidget {
  final List<int> numbers;
  final String classification;
  final bool correct;

  ListItem(
      {required this.numbers,
      required this.classification,
      required this.correct});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            classification,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: correct ? Colors.green : Colors.redAccent,
              fontSize: 20,
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 1.5,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: 50,
          // ),
          NumberLineGraph(
            numbers: numbers,
          ),
          Text(
            "score: " + (correct ? "5" : "0"),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
