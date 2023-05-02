import 'question.dart';
import 'user.dart';

class TriviaRoom {
  final String id;
  final String name;
  final String description;
  final String managerID;
  final List<QuizQuestion> questions;
  final int exerciseTime;
  final int restTime;
  final Map<String, int> scoreboard;
  final String picture;
  final bool isPublic;
  final String password;

  TriviaRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.managerID,
    required this.questions,
    required this.exerciseTime,
    required this.restTime,
    required this.scoreboard,
    required this.picture,
    required this.isPublic,
    required this.password,
  });

  // factory TriviaRoom.fromMap(Map<String, dynamic> data) {
  //   List<QuizQuestion> questions = [];
  //   if (data['questions'] != null) {
  //     for (var questionData in data['questions']) {
  //       questions.add(QuizQuestion.fromMap(questionData));
  //     }
  //   }
  //   return TriviaRoom(
  //     id: data['id'],
  //     name: data['name'],
  //     description: data['description'],
  //     managerID: data['managerID'],
  //     questions: questions,
  //     exerciseTime: data['exerciseTime'],
  //     restTime: data['restTime'],
  //     scoreboard: Map<String, int>.from(data['scoreboard'] ?? {}),
  //     picture: data['picture'],
  //     isPublic: data['isPublic'],
  //     password: data['password'],
  //   );
  // }
}
