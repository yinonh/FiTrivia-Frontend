import 'package:flutter/material.dart';
import '../Models/user.dart';
//import 'package:provider/provider.dart';

// UsersProvider class
class UsersProvider extends ChangeNotifier {
  final List<User> _users = [
    User(
      uid: 'user1',
      username: 'john_doe',
      email: 'johndoe@example.com',
      password: 'password123',
    ),
    User(
      uid: 'user2',
      username: 'jane_smith',
      email: 'janesmith@example.com',
      password: 'password456',
    ),
    User(
      uid: 'user3',
      username: 'bob_johnson',
      email: 'bobjohnson@example.com',
      password: 'password789',
    ),
  ];

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  User? getUserByEmailAndPassword(String email, String password) {
    for (var user in _users) {
      if (user.email == email && user.password == password) {
        return user;
      }
    }
    return null;
  }
}