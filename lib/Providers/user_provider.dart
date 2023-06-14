import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Future<bool> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return true; // Password update successful
      }
      return false; // User not found
    } catch (e) {
      print(e);
      return false; // Password update failed
    }
  }

  Future<bool> updateUserDetails(String userName, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({'userName': userName});

        // Update email if necessary
        if (email.isNotEmpty && email != user.email) {
          await user.updateEmail(email);
        }

        return true; // User details update successful
      }
      return false; // User not found
    } catch (e) {
      print(e);
      return false; // User details update failed
    }
  }

  Future<String?> getUsernameByUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        final username = userData?['userName'] as String?;
        return username;
      }
      return null; // User not found
    } catch (e) {
      print(e);
      return null; // Error occurred while fetching username
    }
  }

  Future<String?> getUserLanguage(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.get('language') as String?;
      }
      return null; // User not found or language field is not set
    } catch (e) {
      print(e);
      return null; // Error occurred while fetching user language
    }
  }

  Future<bool> updateUserLanguage(String userId, String language) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({'language': language});

      return true; // User language update successful
    } catch (e) {
      print(e);
      return false; // User language update failed
    }
  }
  Future<bool> isUserAdmin(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      return userDoc['isAdmin']; // User language update successful
    } catch (e) {
      print(e);
      return false;
    }
  }
}
