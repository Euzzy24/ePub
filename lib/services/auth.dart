import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  User? _user;

  User? get user {
    return _user;
  }

  AuthService() {
    _firebaseAuth.authStateChanges().listen(authStateChange);
  }

  Future<bool> signup(String email, String password, String username) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _usersCollection.add({
        'id': credential.user!.uid,
        'username': username,
        'email': email,
      });
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print('Sign up failed: $e');
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return false;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Sign out failed: $e');
      rethrow;
    }
  }

  void authStateChange(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
