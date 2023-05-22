import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

import '../Providers/trivia_rooms_provider.dart';
import '../Models/trivia_room.dart';
import '../Widgets/scoreboard.dart';
import '../Widgets/result_list_item.dart';
import '../Widgets/navigate_drawer.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/result_screen';
  final List<List<String>> result;
  final Map<String, int> exDict;
  final List<int> correctAnsIndex;
  final TriviaRoom room;
  late final Map<String, int> scoresDict;
  String userID = FirebaseAuth.instance.currentUser!.uid;

  ResultScreen(
      {required this.result,
      required this.exDict,
      required this.correctAnsIndex,
      required this.room,
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
    if (inputList.length == 0) return [];
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
      drawer: NavigateDrawer(),
      appBar: AppBar(
        title: Text('Result Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        50) *
                    0.28,
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
              Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        50) *
                    0.72,
                child: FutureBuilder(
                  future: Provider.of<TriviaRoomProvider>(context,
                          listen: false)
                      .add_score(widget.room, widget.userID, get_total_score()),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Text('IS EMPTY');
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Scoreboard(
                              userScores: snapshot.data!,
                              currentUserScore: 150,
                              currentUserID: widget.userID),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('error');
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  /////
                ),
              ),
              Center(
                child: Container(
                  height: 50,
                  child: Text(
                    "Total score: ${get_total_score()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
