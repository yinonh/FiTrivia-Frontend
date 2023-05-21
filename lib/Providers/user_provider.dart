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
}
