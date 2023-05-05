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
  final List<TriviaRoom> _triviaRooms = [
    TriviaRoom(
      id: "1",
      name: 'Music',
      description: 'A trivia room for music',
      managerID: 'user1',
      questions: [
        QuizQuestion(
          id: "1",
          correctAnswer: "Guitar",
          incorrectAnswers: ["Piano", "Drums", "Saxophone"],
          question: "With Which Instrument Is Les Paul Associated?",
          difficulty: "easy",
        ),
        QuizQuestion(
          id: "2",
          correctAnswer: "The Cure",
          incorrectAnswers: ["Level 42", "Deep Purple", "Snow Patrol"],
          question:
              "Which English rock band released the album 'Seventeen Seconds'?",
          difficulty: "hard",
        ),
        QuizQuestion(
          id: "3",
          correctAnswer: "Bob Dylan",
          incorrectAnswers: ["Bruce Springsteen", "David Bowie", "Neil Young"],
          question: "Who Released The 70's Album Entitled Blood on the Tracks?",
          difficulty: "medium",
        ),
      ],
      exerciseTime: 30,
      restTime: 10,
      scoreboard: {
        "user1": 10,
        "user2": 5,
        "user3": 3,
      },
      picture: 'assets/music.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "2",
      name: 'Film & TV',
      description: 'A trivia room for movie buffs',
      managerID: 'user2',
      questions: [
        QuizQuestion(
          id: "1",
          correctAnswer: "Darth Vader",
          incorrectAnswers: ["Obi-Wan Kenobi", "Han Solo", "Yoda"],
          question: "In Star Wars, who is Luke Skywalker's father?",
          difficulty: "medium",
        ),
        QuizQuestion(
          id: "2",
          correctAnswer: "1963",
          incorrectAnswers: ["1957", "1969", "1975"],
          question: "In which year was The Great Escape released?",
          difficulty: "hard",
        ),
        QuizQuestion(
          id: "3",
          correctAnswer: "Roberto Benigni",
          incorrectAnswers: ["Tom Hanks", "Ian McKellen", "Nick Nolte"],
          question:
              "Who won the 1998 Academy Award for Best Leading Actor for playing the role of Guido in Life Is Beautiful?",
          difficulty: "hard",
        ),
      ],
      exerciseTime: 30,
      restTime: 10,
      scoreboard: {
        "user1": 10,
        "user2": 5,
        "user3": 3,
      },
      picture: 'assets/film_and_tv.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "3",
      name: 'Sport & Leisure',
      description: 'A trivia room for sport',
      managerID: 'user2',
      questions: [
        QuizQuestion(
          id: "1",
          correctAnswer: "Eight",
          incorrectAnswers: ["Four", "Twelve", "Sixteen"],
          question:
              "How Many Lanes Does An Olympic Standard Swimming Pool Have?",
          difficulty: "medium",
        ),
        QuizQuestion(
          id: "2",
          correctAnswer: "Chicago Whitesox",
          incorrectAnswers: [
            "Chicago Orioles",
            "Chicago Reds",
            "Chicago Stars"
          ],
          question: "Which of these is a baseball team based in Chicago?",
          difficulty: "hard",
        ),
        QuizQuestion(
          id: "3",
          correctAnswer: "Boston Red Sox",
          incorrectAnswers: ["Boston United", "Boston Pirates", "Boston Inter"],
          question: "Which of these is a baseball team based in Boston?",
          difficulty: "easy",
        ),
      ],
      exerciseTime: 30,
      restTime: 10,
      scoreboard: {
        "user1": 10,
        "user2": 5,
        "user3": 3,
      },
      picture: 'assets/sport_and_leisure.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "4",
      name: 'Geography',
      description: 'A trivia room for around the world',
      managerID: 'user2',
      questions: [
        QuizQuestion(
          id: "1",
          correctAnswer: "Jerusalem",
          incorrectAnswers: ["Paris", "Rome", "Istanbul"],
          question:
              "The \"Old City\" of this location is divided into four quarters — a Christian quarter, a Muslim Quarter, a Jewish Quarter, and an Armenian Quarter.",
          difficulty: "medium",
        ),
        QuizQuestion(
          id: "2",
          correctAnswer: "Rio De Janeiro",
          incorrectAnswers: ["Caracas", "San Juan", "Montevideo"],
          question: "Which of these cities is in Brazil?",
          difficulty: "easy",
        ),
        QuizQuestion(
          id: "3",
          correctAnswer: "Canada",
          incorrectAnswers: ["Australia", "New Zealand", "United States"],
          question: "Where would you find the city of Vancouver?",
          difficulty: "easy",
        ),
      ],
      exerciseTime: 30,
      restTime: 10,
      scoreboard: {
        "user1": 10,
        "user2": 5,
        "user3": 3,
      },
      picture: 'assets/geography.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "5",
      name: 'Food & Drink',
      description: 'A trivia room for food and drinks',
      managerID: 'user2',
      questions: [
        QuizQuestion(
          id: "1",
          correctAnswer: "Jerusalem",
          incorrectAnswers: ["Raspberry", "Orange", "Banana"],
          question: "Laetrile is associated with the which fruit?",
          difficulty: "hard",
        ),
        QuizQuestion(
          id: "2",
          correctAnswer: "Aloco",
          incorrectAnswers: ["Borscht", "Shawarma", "Dholl Puri"],
          question:
              "Which of these dishes is most associated with Côte d'Ivoire?",
          difficulty: "hard",
        ),
        QuizQuestion(
          id: "3",
          correctAnswer: "Iceland",
          incorrectAnswers: ["The Czech Republic", "Austria", "Nepal"],
          question: "Which country is associated with the drink brennivín?",
          difficulty: "hard",
        ),
      ],
      exerciseTime: 30,
      restTime: 10,
      scoreboard: {
        "user1": 10,
        "user2": 5,
        "user3": 3,
      },
      picture: 'assets/food_and_drink.png',
      isPublic: true,
      password: '',
    ),
  ];

  List<TriviaRoom> get triviaRooms => _triviaRooms;

  List<String> get publicTriviaRooms => _publicTriviaRooms;

  void addRoom(TriviaRoom room) {
    _triviaRooms.add(room);
    notifyListeners();
  }

  void editRoom(TriviaRoom room) {
    int index = _triviaRooms.indexWhere((r) => r.id == room.id);
    if (index >= 0) {
      _triviaRooms[index] = room;
      notifyListeners();
    }
  }

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

  List<QuizQuestion> getQuestionsForRoom(String roomId) {
    TriviaRoom? room = _triviaRooms.firstWhere((room) => room.id == roomId);
    if (room == null) {
      // handle error
      return [];
    }
    return room.questions;
  }

  TriviaRoom getRoomById(String roomId) {
    return _triviaRooms.firstWhere((room) => room.id == roomId);
  }

  Future<void> removeRoom(String roomId) async{
    try {
      await FirebaseFirestore.instance
          .collection('TriviaRooms')
          .doc(roomId)
          .delete().timeout(Duration(seconds: 60));
      notifyListeners(); //TODO: Why it is needed?
    } on TimeoutException catch (e) {
      throw Exception('Timeout Error');
    }
  }
}
