import 'package:flutter/material.dart';
import '../Widgets/chart.dart';

class ListItem extends StatelessWidget {
  final List<int> numbers;

  ListItem({required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Squat"),
          SizedBox(width: 50,),
          NumberLineGraph(
            numbers: numbers,
          ),
        ],
      ),
    );
  }
}
