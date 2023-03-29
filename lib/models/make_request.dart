import 'dart:convert';
import 'question.dart';

import 'package:http/http.dart' as http;

Future<List<QuizQuestion>> fetchQuestions() async {
  final response = await http.get(Uri.parse(
      'https://the-trivia-api.com/api/questions?limit=2&categories=science'));

  if (response.statusCode == 200) {
    final jsonList = json.decode(response.body);
    return QuizQuestion.fromJsonList(jsonList);
  } else {
    throw Exception('Failed to fetch questions');
  }
}
