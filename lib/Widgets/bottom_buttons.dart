import 'package:flutter/material.dart';

class bottom_buttons extends StatelessWidget {
  bottom_buttons({required this.correctAnswer, required this.wrongAnswers});
  final String correctAnswer;
  final List<String> wrongAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: MediaQuery.of(context).size.width >= 1100
          ? _buildGridButtons()
          : _buildListButtons(),
    );
  }

  Widget _buildGridButtons() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      childAspectRatio: 10 / 1,
      shrinkWrap: true,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text(
            correctAnswer,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            wrongAnswers[0],
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            wrongAnswers[1],
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            wrongAnswers[2],
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ].map((e) => Padding(padding: EdgeInsets.all(8.0), child: e)).toList(),
    );
  }

  Widget _buildListButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              wrongAnswers[0],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              correctAnswer,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              wrongAnswers[1],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              wrongAnswers[2],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }
}
