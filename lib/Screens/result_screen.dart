import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

import '../l10n/app_localizations.dart';
import '../Models/trivia_room.dart';
import '../Providers/trivia_rooms_provider.dart';
import '../Providers/music_provider.dart';
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
  int correctAnswers = 0;
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    playCheering();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
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

  Future<void> playCheering() async {
    Provider.of<MusicProvider>(context, listen: false).startCheeringMusic();
    Provider.of<MusicProvider>(context, listen: false).resumeBgMusic();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  int get_total_score() {
    int total_score = 0;
    widget.correctAnswers = 0;
    for (int i = 0; i < widget.result.length; i++) {
      bool correctAns = is_ans_correct(widget.result[i], i);
      total_score += convertStringList(widget.result[i]).sum;
      total_score += correctAns ? 10 : 0;
      widget.correctAnswers += correctAns ? 1 : 0;
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
        title: Text(
          AppLocalizations.of(context).translate('Result Screen'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 5,
              minBlastForce: 2,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              gravity: 0.2,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.purple,
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            50) *
                        0.38,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    ListItem(
                                      numbers: convertStringList(sublist),
                                      classification:
                                          getMostFrequentValue(sublist),
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
                        0.62,
                    child: FutureBuilder(
                      future: Provider.of<TriviaRoomProvider>(context,
                              listen: false)
                          .add_score(widget.room, widget.userID,
                              get_total_score(), widget.correctAnswers),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return Text(
                              AppLocalizations.of(context)
                                  .translate('IS EMPTY'),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: Scoreboard(
                                userScores: snapshot.data!,
                                currentUserID: widget.userID,
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text(
                            AppLocalizations.of(context).translate('Error'),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 50,
                      child: Text(
                        AppLocalizations.of(context).translate('Total score') +
                            ": ${get_total_score()}",
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
        ],
      ),
    );
  }
}
