class FirebaseExceptionHandler {
  String friendlyFirebaseMessage(String code) {
    // print('sheik$code');
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email.';
      case 'invalid-credential':
        return 'Incorrect password. Please try again.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
