import 'package:flutter/material.dart';
import 'dart:math';

class WheelScreen extends StatefulWidget {
  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  late FixedExtentScrollController _controller;
  final List<String> _roomTitles = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
  ];

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.rotate_right),
            style: const ButtonStyle(
                iconColor: MaterialStatePropertyAll(Colors.black)),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Calculate the total number of items in the ListWheelScrollView
          final itemCount = _roomTitles.length;

          // Calculate the number of times to rotate the ListWheelScrollView (between 2 and 5 rotations)
          final numRotations = Random().nextInt(4) + 2;

          // Calculate the index of the item to stop on (randomly chosen between 0 and itemCount - 1)
          final stopIndex = Random().nextInt(itemCount);

          // Calculate the target item index after all rotations are complete
          final targetIndex =
              (stopIndex + numRotations * itemCount) % itemCount;

          // Animate the ListWheelScrollView to the target index with a duration based on the number of rotations
          _controller.animateToItem(
            targetIndex,
            duration: Duration(seconds: numRotations),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: ListWheelScrollView.useDelegate(
        itemExtent: 200,
        controller: _controller,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: _roomTitles
              .map(
                (title) => Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(title),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
