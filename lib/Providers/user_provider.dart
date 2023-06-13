import 'dart:async';
//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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

  Future<String?> checkExistingProfileImage(String userId) async {
    final storage = FirebaseStorage.instance;
    final reference = storage.ref().child('Profile images/$userId.jpg');

    try {
      final url = await reference.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> loadImageFromUrl(String imageUrl) async {
    final http.Client client = http.Client();
    Uint8List? imageBytes = null;
    try {
      final http.Response response = await client.get(Uri.parse(imageUrl));
      imageBytes = response.bodyBytes;
    } catch (e) {
      print('Error loading profile image: $e');
    } finally {
      client.close();
      return imageBytes;
    }
  }

  Future<bool> uploadImageToFirebase(BuildContext context, File? image,
      Uint8List? imageBytes, String userID) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    bool result = false;

    try {
      notifyListeners();

      if (image != null || imageBytes != null) {
        final reference = storage.ref().child('Profile images/$userID.jpg');

        if (image != null) {
          await reference.putFile(image);
        } else if (imageBytes != null) {
          await reference.putData(imageBytes);
        }

        // Show a success message
        result = true;
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
      return result;
    }
  }
}
