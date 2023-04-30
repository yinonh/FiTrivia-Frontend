import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/trivia_room.dart';
import '../Models/question.dart';
import '../Models/user.dart';

class TriviaRoomProvider with ChangeNotifier {
  final List<TriviaRoom> _triviaRooms = [
    TriviaRoom(
      id: "1",
      name: 'Music',
      description: 'A trivia room for music',
      manager: User(
          uid: 'user1',
          username: 'john_doe',
          email: 'johndoe@example.com',
          password: 'password123'),
      questions: [
        QuizQuestion(
          category: "music",
          id: "1",
          correctAnswer: "Guitar",
          incorrectAnswers: ["Piano", "Drums", "Saxophone"],
          question: "With Which Instrument Is Les Paul Associated?",
          difficulty: "easy",
        ),
        QuizQuestion(
          category: "music",
          id: "2",
          correctAnswer: "The Cure",
          incorrectAnswers: ["Level 42", "Deep Purple", "Snow Patrol"],
          question:
              "Which English rock band released the album 'Seventeen Seconds'?",
          difficulty: "hard",
        ),
        QuizQuestion(
          category: "music",
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
      manager: User(
          uid: 'user2',
          username: 'jane_smith',
          email: 'janesmith@example.com',
          password: 'password456'),
      questions: [
        QuizQuestion(
          category: "Film & TV",
          id: "1",
          correctAnswer: "Darth Vader",
          incorrectAnswers: ["Obi-Wan Kenobi", "Han Solo", "Yoda"],
          question: "In Star Wars, who is Luke Skywalker's father?",
          difficulty: "medium",
        ),
        QuizQuestion(
          category: "Film & TV",
          id: "2",
          correctAnswer: "1963",
          incorrectAnswers: ["1957", "1969", "1975"],
          question: "In which year was The Great Escape released?",
          difficulty: "hard",
        ),
        QuizQuestion(
          category: "Film & TV",
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
      picture: 'assets/movie_trivia.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "3",
      name: 'Sport & Leisure',
      description: 'A trivia room for sport',
      manager: User(
          uid: 'user2',
          username: 'jane_smith',
          email: 'janesmith@example.com',
          password: 'password456'),
      questions: [
        QuizQuestion(
          category: "Sport & Leisure",
          id: "1",
          correctAnswer: "Eight",
          incorrectAnswers: ["Four", "Twelve", "Sixteen"],
          question:
              "How Many Lanes Does An Olympic Standard Swimming Pool Have?",
          difficulty: "medium",
        ),
        QuizQuestion(
          category: "Sport & Leisure",
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
          category: "Sport & Leisure",
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
      picture: 'assets/Sport.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "4",
      name: 'Geography',
      description: 'A trivia room for around the world',
      manager: User(
          uid: 'user2',
          username: 'jane_smith',
          email: 'janesmith@example.com',
          password: 'password456'),
      questions: [
        QuizQuestion(
          category: "Geography",
          id: "1",
          correctAnswer: "Jerusalem",
          incorrectAnswers: ["Paris", "Rome", "Istanbul"],
          question:
              "The \"Old City\" of this location is divided into four quarters — a Christian quarter, a Muslim Quarter, a Jewish Quarter, and an Armenian Quarter.",
          difficulty: "medium",
        ),
        QuizQuestion(
          category: "Geography",
          id: "2",
          correctAnswer: "Rio De Janeiro",
          incorrectAnswers: ["Caracas", "San Juan", "Montevideo"],
          question: "Which of these cities is in Brazil?",
          difficulty: "easy",
        ),
        QuizQuestion(
          category: "Geography",
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
      picture: 'assets/Geography.png',
      isPublic: true,
      password: '',
    ),
    TriviaRoom(
      id: "5",
      name: 'Food & Drink',
      description: 'A trivia room for food and drinks',
      manager: User(
          uid: 'user2',
          username: 'jane_smith',
          email: 'janesmith@example.com',
          password: 'password456'),
      questions: [
        QuizQuestion(
          category: "Apricot",
          id: "1",
          correctAnswer: "Jerusalem",
          incorrectAnswers: ["Raspberry", "Orange", "Banana"],
          question: "Laetrile is associated with the which fruit?",
          difficulty: "hard",
        ),
        QuizQuestion(
          category: "Food & Drink",
          id: "2",
          correctAnswer: "Aloco",
          incorrectAnswers: ["Borscht", "Shawarma", "Dholl Puri"],
          question:
              "Which of these dishes is most associated with Côte d'Ivoire?",
          difficulty: "hard",
        ),
        QuizQuestion(
          category: "Food & Drink",
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
      picture: 'assets/food.png',
      isPublic: true,
      password: '',
    ),
  ];

  List<TriviaRoom> get triviaRooms => _triviaRooms;

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

  void deleteRoom(int id) {
    _triviaRooms.removeWhere((room) => room.id == id);
    notifyListeners();
  }

  List<QuizQuestion> getQuestionsForRoom(String roomId) {
    TriviaRoom? room = _triviaRooms.firstWhere((room) => room.id == roomId);
    if (room == null) {
      // handle error
      return [];
    }
    return room.questions;
  }
}
