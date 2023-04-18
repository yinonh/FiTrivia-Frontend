import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Widgets/result_list_item.dart';

class ResultScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: result.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            List<String> sublist = result[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  ListItem(
                    numbers: convertStringList(sublist),
                    classification: getMostFrequentValue(sublist),
                    correct: exDict[getMostFrequentValue(sublist)] ==
                        correctAnsIndex[index],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
