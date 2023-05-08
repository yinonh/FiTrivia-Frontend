import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/trivia_room.dart';
import '../Models/question.dart';

class TriviaRoomProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> _publicTriviaRooms = [
    "music",
    "sport_and_leisure",
    "film_and_tv",
    "arts_and_literature",
    "history",
    "society_and_culture",
    "science",
    "geography",
    "food_and_drink",
    "general_knowledge",
  ];

  List<String> get publicTriviaRooms => _publicTriviaRooms;

  String convertCategory(String category) {
    List<String> words = category.split('_');
    words = words
        .map((word) => "${word[0].toUpperCase()}${word.substring(1)}")
        .toList();
    return words.join(' ');
  }

  Future<List<QuizQuestion>> fetchQuestions(String category, int number) async {
    final response = await http.get(Uri.parse(
        'https://the-trivia-api.com/api/questions?limit=$number&categories=$category'));

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      return QuizQuestion.fromJsonList(jsonList);
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<List<Map<String, dynamic>>> getTriviaRoomsByManagerID(
      String managerID) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('TriviaRooms')
        .where('managerID', isEqualTo: managerID)
        .get();

    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'],
              'description': doc['description']
            })
        .toList();
  }

  Future<TriviaRoom> getTriviaRoomById(String id) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('TriviaRooms')
        .doc(id)
        .get();

    final List<String> questionIds = List<String>.from(doc['questions']);

    final List<QuizQuestion> questions = await getQuestionsByIds(questionIds);

    return TriviaRoom(
      id: id,
      name: doc['name'],
      description: doc['description'],
      managerID: doc['managerID'],
      questions: questions,
      exerciseTime: doc['exerciseTime'],
      restTime: doc['restTime'],
      scoreboard: Map<String, int>.from(doc['scoreboard']),
      picture: doc['picture'],
      isPublic: doc['isPublic'],
      password: doc['password'],
    );
  }

  Future<List<QuizQuestion>> getQuestionsByIds(List<String> ids) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Question')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs.map((doc) {
      final List<String> incorrectAnswers =
          List<String>.from(doc['incorrectAnswers']);
      return QuizQuestion(
        id: doc.id,
        correctAnswer: doc['correctAnswer'],
        incorrectAnswers: incorrectAnswers,
        question: doc['question'],
        difficulty: doc['difficulty'],
      );
    }).toList();
  }

  Future<void> removeRoom(String roomId) async {
    try {
      final roomSnapshot = await FirebaseFirestore.instance
          .collection('TriviaRooms')
          .doc(roomId)
          .get();
      final List<String> questionIds =
      List<String>.from(roomSnapshot.data()!['questions'] ?? []);
      final batch = FirebaseFirestore.instance.batch();
      for (final questionId in questionIds) {
        batch.delete(
            FirebaseFirestore.instance.collection('Question').doc(questionId));
      }
      batch.delete(FirebaseFirestore.instance.collection('TriviaRooms').doc(roomId));
      await batch.commit().timeout(Duration(seconds: 60));
      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Timeout Error');
    }
  }


  Future<bool> addTriviaRoom(TriviaRoom triviaRoom) async {
    final roomsCollection = FirebaseFirestore.instance.collection('TriviaRooms');
    final questionsCollection = FirebaseFirestore.instance.collection('Question');

    final questionIDs = await Future.wait(
        triviaRoom.questions.map((question) => questionsCollection.add({
          'question': question.question,
          'correctAnswer': question.correctAnswer,
          'incorrectAnswers': question.incorrectAnswers,
          'difficulty': question.difficulty,
        }).then((docRef) => docRef.id)));

    try {
      await roomsCollection.add({
        'name': triviaRoom.name,
        'description': triviaRoom.description,
        'managerID': triviaRoom.managerID,
        'questions': questionIDs,
        'exerciseTime': triviaRoom.exerciseTime,
        'restTime': triviaRoom.restTime,
        'scoreboard': triviaRoom.scoreboard,
        'picture': triviaRoom.picture,
        'isPublic': triviaRoom.isPublic,
        'password': triviaRoom.password,
      });
      return true;
    } catch (e) {
      print('Error adding trivia room: $e');
      return false;
    }
  }

}
