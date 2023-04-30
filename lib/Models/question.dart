import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizQuestion {
  final String category;
  final String id;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;
  final String difficulty;

  QuizQuestion({
    required this.category,
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      category: json['category'],
      id: json['id'],
      correctAnswer: json['correctAnswer'],
      incorrectAnswers: List<String>.from(json['incorrectAnswers']),
      question: json['question'],
      difficulty: json['difficulty'],
    );
  }

  static List<QuizQuestion> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => QuizQuestion.fromJson(json)).toList();
  }


  static Future<List<QuizQuestion>> fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://the-trivia-api.com/api/questions?limit=5&categories=science'));

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      return QuizQuestion.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to fetch questions');
    }
  }
}