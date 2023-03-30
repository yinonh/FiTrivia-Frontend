import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class bottom_buttons extends StatefulWidget {
  bottom_buttons(
      {required this.correctAnswer, required this.wrongAnswers, Key? key})
      : super(key: key);
  final String correctAnswer;
  final List<String> wrongAnswers;

  @override
  State<bottom_buttons> createState() => _bottom_buttonsState();
}

class _bottom_buttonsState extends State<bottom_buttons> {
  late List<String> answers;
  int _lastPressedIndex = -1;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _shuffleAnswers();
  }

  @override
  void didUpdateWidget(bottom_buttons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.correctAnswer != oldWidget.correctAnswer ||
        !listEquals(widget.wrongAnswers, oldWidget.wrongAnswers)) {
      _lastPressedIndex = -1;
      done = false;
      _shuffleAnswers();
    }
  }

  void _shuffleAnswers() {
    answers = [widget.correctAnswer, ...widget.wrongAnswers]..shuffle();
  }

  void button_pressed(int i) {
    setState(() {
      _lastPressedIndex = i;
      done = true;
    });
  }

  List<ElevatedButton> get_questions_for_grid() {
    List<ElevatedButton> result = [];
    for (var i = 0; i < 4; i++) {
      result.add(ElevatedButton(
        style: _lastPressedIndex == i
            ? ElevatedButton.styleFrom(
                backgroundColor: done && answers[i] == widget.correctAnswer
                    ? Colors.green
                    : Colors.deepOrange[300],
                side: BorderSide(
                  width: 5.0,
                  color: Colors.black,
                ),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: done && answers[i] == widget.correctAnswer
                    ? Colors.green
                    : Colors.blue,
              ),
        onPressed: () {
          button_pressed(i);
        },
        child: Text(
          textAlign: TextAlign.center,
          answers[i],
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    }
    return result;
  }

  List<Widget> get_questions_for_list() {
    List<Widget> result = [];
    for (var i = 0; i < 4; i++) {
      result.add(
        Expanded(
          child: ElevatedButton(
            style: _lastPressedIndex == i
                ? ElevatedButton.styleFrom(
                    backgroundColor: done && answers[i] == widget.correctAnswer
                        ? Colors.green
                        : Colors.deepOrange[300],
                    side: BorderSide(
                      width: 5.0,
                      color: Colors.black,
                    ),
                  )
                : ElevatedButton.styleFrom(
                    backgroundColor: done && answers[i] == widget.correctAnswer
                        ? Colors.green
                        : Colors.blue,
                  ),
            onPressed: () {
              button_pressed(i);
            },
            child: Text(
              textAlign: TextAlign.center,
              answers[i],
              style: TextStyle(fontSize: 20.0),
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
      children: get_questions_for_grid()
          .map((e) => Padding(padding: EdgeInsets.all(8.0), child: e))
          .toList(),
    );
  }

  Widget _buildListButtons() {
    //List<String> answers = [correctAnswer, ...wrongAnswers]..shuffle();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: get_questions_for_list());
  }
}
