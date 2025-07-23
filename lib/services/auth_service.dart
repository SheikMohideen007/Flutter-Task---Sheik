import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/utils/exception_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Listen to auth state changes (Sigin or Signout)
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Sign In
  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign Up
  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Try again.';
    }
  }

  // Current user getter
  User? get currentUser => _auth.currentUser;
}
