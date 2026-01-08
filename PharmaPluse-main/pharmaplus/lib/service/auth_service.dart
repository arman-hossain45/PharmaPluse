import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // লগইন করা এবং role চেক করা
  Future<String?> loginAndGetRole(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Firestore থেকে role নিয়ে আসা
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['role'] as String?;
      }
    } on FirebaseAuthException catch (e) {
      return null; // লগইন ফেল হলে
    }
    return null;
  }

  // লগআউট
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // বর্তমান ইউজারের role চেক (যদি লগইন থাকে)
  Future<String?> getCurrentUserRole() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      return userDoc['role'] as String?;
    }
    return null;
  }
}