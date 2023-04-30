import 'package:flutter/material.dart';
import 'question.dart';
import 'user.dart';

class TriviaRoom {
  final String id;
  final String name;
  final String description;
  final User manager;
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
    required this.manager,
    required this.questions,
    required this.exerciseTime,
    required this.restTime,
    required this.scoreboard,
    required this.picture,
    required this.isPublic,
    required this.password,
  });
}
