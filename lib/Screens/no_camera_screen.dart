import 'package:flutter/material.dart';
import '../Widgets/bottom_buttons.dart';

import '../models/make_request.dart';
import '../models/question.dart';

class NoCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<QuizQuestion>>? _futureQuestions;

  @override
  void initState() {
    super.initState();

    _futureQuestions = fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia'),
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
                    aspectRatio: 10 / 6,
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
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data');
                      } else {
                        return Text(
                          snapshot.data![0].question,
                          style: TextStyle(fontSize: 20.0),
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
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data');
                    } else {
                      return bottom_buttons(
                        correctAnswer: snapshot.data![0].correctAnswer,
                        wrongAnswers: snapshot.data![0].incorrectAnswers,
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
