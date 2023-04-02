import 'package:flutter/material.dart';
import '../Widgets/bottom_buttons.dart';

import '../models/make_request.dart';
import '../models/question.dart';

class NoCameraScreen extends StatefulWidget {
  @override
  State<NoCameraScreen> createState() => _NoCameraScreenState();
}

class _NoCameraScreenState extends State<NoCameraScreen> {
  Future<List<QuizQuestion>>? _futureQuestions;
  int questionsLength = 0;
  int index = 0;

  @override
  void initState() {
    super.initState();

    _futureQuestions = fetchQuestions();
    _futureQuestions?.then((questions) {
      questionsLength = questions.length;
    });
  }

  void next_question() {
    setState(() {
      if (index + 1 < questionsLength) index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: next_question,
            icon: Icon(Icons.navigate_next_rounded),
          )
        ],
        title: Text('FiTrivia'),
        centerTitle: true,
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height * 0.5,
        //width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            Container(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).viewPadding.top) *
                    (MediaQuery.of(context).size.height <
                            MediaQuery.of(context).size.width
                        ? 0.6
                        : 0.5),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: MediaQuery.of(context).size.height <
                            MediaQuery.of(context).size.width
                        ? 10 / 6
                        : 4 / 6,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                )),
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  0.1,
              child: Center(
                child: FutureBuilder<List<QuizQuestion>>(
                    future: _futureQuestions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          strokeWidth: 5,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data');
                      } else {
                        return Text(
                          snapshot.data![index].question,
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center,
                        );
                      }
                    }),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).viewPadding.top) *
                  (MediaQuery.of(context).size.height <
                          MediaQuery.of(context).size.width
                      ? 0.3
                      : 0.4),
              child: FutureBuilder<List<QuizQuestion>>(
                  future: _futureQuestions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data');
                    } else {
                      return bottom_buttons(
                        correctAnswer: snapshot.data![index].correctAnswer,
                        wrongAnswers: snapshot.data![index].incorrectAnswers,
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
