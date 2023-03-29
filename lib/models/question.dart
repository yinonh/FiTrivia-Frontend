class QuizQuestion {
  final String category;
  final String id;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;
  final List<String> tags;
  final String type;
  final String difficulty;
  final List<String> regions;
  final bool isNiche;

  QuizQuestion({
    required this.category,
    required this.id,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
    required this.tags,
    required this.type,
    required this.difficulty,
    required this.regions,
    required this.isNiche,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      category: json['category'],
      id: json['id'],
      correctAnswer: json['correctAnswer'],
      incorrectAnswers: List<String>.from(json['incorrectAnswers']),
      question: json['question'],
      tags: List<String>.from(json['tags']),
      type: json['type'],
      difficulty: json['difficulty'],
      regions: List<String>.from(json['regions']),
      isNiche: json['isNiche'],
    );
  }

  static List<QuizQuestion> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => QuizQuestion.fromJson(json)).toList();
  }
}
