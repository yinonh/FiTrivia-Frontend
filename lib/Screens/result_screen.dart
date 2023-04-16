import 'package:flutter/material.dart';
import '../Widgets/chart.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result_screen';
  final List<List<String>> result;

  ResultScreen({required this.result, Key? key}) : super(key: key);

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
                    Expanded(
                      child: NumberLineGraph(numbers: [1,1,1,2])//convertStringList(sublist)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
