import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Widgets/result_list_item.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/result_screen';
  final List<List<String>> result;
  final Map<String, int> exDict;
  final List<int> correctAnsIndex;

  ResultScreen(
      {required this.result,
      required this.exDict,
      required this.correctAnsIndex,
      Key? key})
      : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final List<List<String>> _resultList = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _resultList.addAll(widget.result);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get_total_score() {
    int total_score = 0;
    for (int i = 0; i < widget.result.length; i++) {
      total_score += convertStringList(widget.result[i]).sum;
      total_score += is_ans_correct(widget.result[i], i) ? 10 : 0;
    }
    return total_score;
  }

  List<int> convertStringList(List<String> inputList) {
    Map<String, int> frequencies = {};
    int maxFreq = 0;
    String mostCommonValue = '';

    // Count the frequencies of the values in the input list
    for (String value in inputList) {
      if (value == 'stand') {
        frequencies[value] = (frequencies[value] ?? 0) + 1;
      } else {
        frequencies[value] = (frequencies[value] ?? 0) + 1;
        if (frequencies[value]! > maxFreq) {
          maxFreq = frequencies[value]!;
          mostCommonValue = value;
        }
      }
    }

    // Create the output list based on the input list and the most common value
    List<int> outputList = [];
    for (String value in inputList) {
      if (value == 'stand') {
        outputList.add(0);
      } else if (value == mostCommonValue) {
        outputList.add(2);
      } else {
        outputList.add(1);
      }
    }
    return outputList;
  }

  String getMostFrequentValue(List<String> stringList) {
    if (stringList.isEmpty) {
      return "Error";
    }

    final frequencyMap = groupBy<String, String>(stringList, (value) => value);
    final mostFrequentEntry = frequencyMap.entries
        .reduce((a, b) => a.value.length > b.value.length ? a : b);

    return mostFrequentEntry.key;
  }

  bool is_ans_correct(List<String> sublist, int index) {
    if (widget.exDict[getMostFrequentValue(sublist)] ==
        widget.correctAnsIndex[index]) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _resultList.length,
                itemBuilder: (BuildContext context, int index) {
                  List<String> sublist = _resultList[index];
                  return Column(
                    children: [
                      SlideTransition(
                        position: _animation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              ListItem(
                                numbers: convertStringList(sublist),
                                classification: getMostFrequentValue(sublist),
                                correct: is_ans_correct(sublist, index),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: Text(
                "Total score: ${get_total_score()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
