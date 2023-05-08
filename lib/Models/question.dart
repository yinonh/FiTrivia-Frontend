class QuizQuestion {
  final String id;
  final String correctAnswer;
  late final List<String> incorrectAnswers;
  final String question;
  final String difficulty;

  QuizQuestion({
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.difficulty,
  });

  @override
  String toString() {
    return 'QuizQuestion{id: $id, '
        'correctAnswer: $correctAnswer, '
        'incorrectAnswers: $incorrectAnswers, '
        'question: $question, '
        'difficulty: $difficulty}';
  }

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

  QuizQuestion copyWith({
    String? id,
    String? correctAnswer,
    List<String>? incorrectAnswers,
    String? question,
    String? difficulty,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      question: question ?? this.question,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
