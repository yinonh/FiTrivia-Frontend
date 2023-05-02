class QuizQuestion {
  final String id;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;
  final String difficulty;

  QuizQuestion({
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
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

  // factory QuizQuestion.fromMap(Map<String, dynamic> data) {
  //   return QuizQuestion(
  //     id: data['id'],
  //     correctAnswer: data['correctAnswer'],
  //     incorrectAnswers: List<String>.from(data['incorrectAnswers']),
  //     question: data['question'],
  //     difficulty: data['difficulty'],
  //   );
  // }
}
