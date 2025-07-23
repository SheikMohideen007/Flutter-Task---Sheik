import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/utils/exception_handler.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  //Here I'm Setting Auth mode: true = login, false = register
  bool _isLogin = true;
  bool get isLogin => _isLogin;

  void toggleMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptionHandler().friendlyFirebaseMessage(e.code);
    } catch (e) {
      throw Exception("Unknown error occurred during login.");
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseExceptionHandler().friendlyFirebaseMessage(e.code);
    } catch (e) {
      throw Exception("Unknown error occurred during registration.");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed. Try again.");
    }
  }
}
