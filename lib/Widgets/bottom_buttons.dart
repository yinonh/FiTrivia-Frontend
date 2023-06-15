import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnswerButtons extends StatelessWidget {
  const AnswerButtons(
      {required this.correctAnswer,
      required this.allAnswers,
      required this.lastPressedIndex,
      required this.done,
      required this.exDict,
      Key? key})
      : super(key: key);
  final String correctAnswer;
  final List<String> allAnswers;
  final int lastPressedIndex;
  final bool done;
  final Map<int, String> exDict;

  List<ElevatedButton> get_questions_for_grid(List<String> answers) {
    List<ElevatedButton> result = [];
    for (var i = 0; i < 4; i++) {
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: done && answers[i] == correctAnswer
                ? Colors.green
                : lastPressedIndex == i && done && answers[i] != correctAnswer
                    ? Colors.deepOrange[300]
                    : null,
            side: lastPressedIndex == i
                ? BorderSide(width: 5.0, color: Colors.black)
                : null,
          ),
          onPressed: () {
            //button_pressed(i, true);
          },
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/${exDict[i]}.gif',
                  width: 250,
                  height: 250,
                ),
              ),
              SizedBox(
                  width: 16.0), // add some spacing between the image and text
              Flexible(
                flex: 6,
                child: AutoSizeText(
                  textAlign: TextAlign.center,
                  answers[i],
                  style: TextStyle(fontSize: 40),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return result;
  }

  List<Widget> get_questions_for_list(List<String> answers) {
    List<Widget> result = [];
    for (var i = 0; i < 4; i++) {
      result.add(
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: done && answers[i] == correctAnswer
                  ? Colors.green
                  : lastPressedIndex == i && done && answers[i] != correctAnswer
                      ? Colors.deepOrange[300]
                      : null,
              side: lastPressedIndex == i
                  ? BorderSide(width: 5.0, color: Colors.black)
                  : null,
            ),
            onPressed: () {
              //button_pressed(i, true);
            },
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Image.asset(
                    'assets/${exDict[i]}.gif',
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(
                    width: 16.0), // add some spacing between the image and text
                Flexible(
                  flex: 6,
                  child: AutoSizeText(
                    textAlign: TextAlign.center,
                    answers[i],
                    style: TextStyle(fontSize: 40),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      result.add(SizedBox(height: 16.0));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: MediaQuery.of(context).size.width >= 963
          ? _buildGridButtons()
          : _buildListButtons(),
    );
  }

  Widget _buildGridButtons() {
    //List<String> answers = [correctAnswer, ...wrongAnswers]..shuffle();
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      childAspectRatio: 8 / 1,
      shrinkWrap: true,
      children: get_questions_for_grid(allAnswers)
          .map((e) => Padding(padding: EdgeInsets.all(8.0), child: e))
          .toList(),
    );
  }

  Widget _buildListButtons() {
    //List<String> answers = [correctAnswer, ...wrongAnswers]..shuffle();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: get_questions_for_list(allAnswers));
  }
}
