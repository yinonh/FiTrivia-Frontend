// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import '../Models/question.dart';
//
// class QuizQuestionsProvider extends ChangeNotifier {
//   final DatabaseReference _questionsRef =
//       FirebaseDatabase.instance.ref().child('Questions');
//
//   List<QuizQuestion> _quizQuestions = [];
//
//   List<QuizQuestion> get quizQuestions => _quizQuestions;
//
//   Future<void> fetchQuizQuestions() async {
//     final DatabaseEvent snapshot = await _questionsRef.once();
//     final Map<dynamic, dynamic> data = snapshot.value;
//     final List<QuizQuestion> quizQuestions = [];
//
//     data.forEach((key, value) {
//       quizQuestions.add(
//         QuizQuestion(
//           id: value['id'],
//           category: value['category'],
//           question: value['question'],
//           correctAnswer: value['correctAnswer'],
//           incorrectAnswers: List<String>.from(value['incorrectAnswers']),
//           difficulty: value['difficulty'],
//         ),
//       );
//     });
//
//     _quizQuestions = quizQuestions;
//     notifyListeners();
//   }
// }

// CollectionReference q = FirebaseFirestore.instance.collection('Question');
// DocumentSnapshot result = await q.doc("JLpEzyw98gd3mVgA1vwg").get();
// Map<String, dynamic> data = result.data() as Map<String, dynamic>;
// print(data);
