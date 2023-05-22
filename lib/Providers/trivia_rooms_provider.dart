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
              'description': doc['description'],
              'password': doc['password'],
              'isPublic': doc['isPublic']
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getPublicTriviaRooms() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('TriviaRooms')
        .where('isPublic', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'],
              'description': doc['description'],
            })
        .toList();
  }

  Future<bool> isRoomExistsById(String id) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('TriviaRooms')
        .doc(id)
        .get();
    return doc.exists;
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
      scoreboard: {},
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
      final List<String> scoreboardIds =
          List<String>.from(roomSnapshot.data()!['scoreboard'].values.toList());
      final List<String> questionIds =
          List<String>.from(roomSnapshot.data()!['questions'] ?? []);
      final batch = FirebaseFirestore.instance.batch();
      for (final questionId in questionIds) {
        batch.delete(
            FirebaseFirestore.instance.collection('Question').doc(questionId));
      }
      for (final scoreboardId in scoreboardIds) {
        batch.delete(FirebaseFirestore.instance
            .collection('Scoreboards')
            .doc(scoreboardId));
      }
      batch.delete(
          FirebaseFirestore.instance.collection('TriviaRooms').doc(roomId));
      await batch.commit().timeout(Duration(seconds: 60));
      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Timeout Error');
    }
  }

  Future<bool> addStaticRoom(TriviaRoom triviaRoom) async {
    final roomsCollection =
        FirebaseFirestore.instance.collection('TriviaRooms');
    final scoreboardsCollection =
        FirebaseFirestore.instance.collection('Scoreboards');
    Map<String, String> scoreboardsDict = {};

    for (int questionsAmount = 2; questionsAmount <= 20; questionsAmount++) {
      scoreboardsDict[questionsAmount.toString()] =
          await scoreboardsCollection.add({
        'scores': {},
      }).then((docRef) => docRef.id);
    }
    try {
      await roomsCollection.doc(triviaRoom.id).set({
        'scoreboard': scoreboardsDict,
      });
      return true;
    } catch (e) {
      print('Error adding trivia room: $e');
      return false;
    }
  }

  Future<bool> addTriviaRoom(TriviaRoom triviaRoom) async {
    final roomsCollection =
        FirebaseFirestore.instance.collection('TriviaRooms');
    final questionsCollection =
        FirebaseFirestore.instance.collection('Question');
    final scoreboardsCollection =
        FirebaseFirestore.instance.collection('Scoreboards');

    final questionIDs = await Future.wait(
        triviaRoom.questions.map((question) => questionsCollection.add({
              'question': question.question,
              'correctAnswer': question.correctAnswer,
              'incorrectAnswers': question.incorrectAnswers,
              'difficulty': question.difficulty,
            }).then((docRef) => docRef.id)));
    final scoreboardID = await scoreboardsCollection.add({
      'scores': {},
    }).then((docRef) => docRef.id);
    try {
      await roomsCollection.add({
        'name': triviaRoom.name,
        'description': triviaRoom.description,
        'managerID': triviaRoom.managerID,
        'questions': questionIDs,
        'exerciseTime': triviaRoom.exerciseTime,
        'restTime': triviaRoom.restTime,
        'scoreboard': {questionIDs.length.toString(): scoreboardID},
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

  Future<bool> editTriviaRoom(String roomID, TriviaRoom triviaRoom) async {
    final roomsCollection =
        FirebaseFirestore.instance.collection('TriviaRooms');
    final questionsCollection =
        FirebaseFirestore.instance.collection('Question');

    final questionIDs =
        await Future.wait(triviaRoom.questions.map((question) async {
      if (question.id != '') {
        // If the question already has an ID, update it
        await questionsCollection.doc(question.id).update({
          'question': question.question,
          'correctAnswer': question.correctAnswer,
          'incorrectAnswers': question.incorrectAnswers,
          'difficulty': question.difficulty,
        });
        return question.id;
      } else {
        // If the question doesn't have an ID, add it as a new question
        final newQuestionDocRef = await questionsCollection.add({
          'question': question.question,
          'correctAnswer': question.correctAnswer,
          'incorrectAnswers': question.incorrectAnswers,
          'difficulty': question.difficulty,
        });
        return newQuestionDocRef.id;
      }
    }));
    final DocumentSnapshot oldRoomDoc = await roomsCollection.doc(roomID).get();
    if (!oldRoomDoc['scoreboard'].containsKey(questionIDs.length.toString())) {
      final scoreboardsCollection =
          FirebaseFirestore.instance.collection('Scoreboards');
      final scoreboardID = await scoreboardsCollection.add({
        'scores': [],
      }).then((docRef) => docRef.id);
      await roomsCollection.doc(roomID).update({
        'scoreboard.${questionIDs.length.toString()}': scoreboardID,
      });
    }

    try {
      await roomsCollection.doc(roomID).update({
        'name': triviaRoom.name,
        'description': triviaRoom.description,
        'managerID': triviaRoom.managerID,
        'questions': questionIDs,
        'exerciseTime': triviaRoom.exerciseTime,
        'restTime': triviaRoom.restTime,
        'picture': triviaRoom.picture,
        'isPublic': triviaRoom.isPublic,
        'password': triviaRoom.password,
      });
      return true;
    } catch (e) {
      print('Error editing trivia room: $e');
      return false;
    }
  }

  Future<String> getUsernameById(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return userData['userName'];
  }

  Future<List<Map<String, String>>> add_score(
      TriviaRoom room, String userID, int total_score) async {
    int maxScoreboardSize = 10;
    final roomsCollection =
        FirebaseFirestore.instance.collection('TriviaRooms');
    final scoreboardsCollection =
        FirebaseFirestore.instance.collection('Scoreboards');
    final DocumentSnapshot roomDoc = await roomsCollection.doc(room.id).get();
    String scoreboardID =
        roomDoc['scoreboard'][room.questions.length.toString()];
    print(scoreboardID);
    final DocumentReference scoreboardRef =
        await scoreboardsCollection.doc(scoreboardID);
    final DocumentSnapshot scoreboardDoc = await scoreboardRef.get();
    Map<String, int> scoresDict = {};
    for (var entry in scoreboardDoc['scores'].entries) {
      scoresDict[entry.key] = entry.value;
    }
    if (scoresDict.containsKey(userID)) {
      if (scoresDict[userID]! < total_score) {
        scoresDict[userID] = total_score;
        await scoreboardsCollection.doc(scoreboardID).update({
          'scores.$userID': total_score,
        });
      }
    } else if (scoresDict.length < maxScoreboardSize) {
      scoresDict[userID] = total_score;
      await scoreboardsCollection.doc(scoreboardID).update({
        'scores.$userID': total_score,
      });
    } else {
      int minScore = scoresDict.values.reduce((a, b) => a < b ? a : b);
      if (total_score > minScore) {
        String keyToRemove = scoresDict.entries
            .firstWhere((element) => element.value == minScore)
            .key;
        if (keyToRemove != null) {
          scoresDict.remove(keyToRemove);
          scoresDict[userID] = total_score;
          await scoreboardsCollection.doc(scoreboardID).update({
            'scores': scoresDict,
          });
        }
      }
    }
    List<Map<String, String>> result = [];
    bool isCurrentUserInside = false;
    for (var entry in scoresDict.entries) {
      if (entry.key == userID) {
        isCurrentUserInside = true;
      }
      Map<String, String> x = {};
      x['id'] = entry.key;
      x['score'] = entry.value.toString();
      x['username'] = await getUsernameById(entry.key);
      result.add(x);
    }
    if (!isCurrentUserInside) {
      result.add({
        'id': userID,
        'score': total_score.toString(),
        'username': await getUsernameById(userID),
      });
    }
    return result;
  }
}
