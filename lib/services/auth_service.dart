import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      print('AuthService: Attempting sign in for $email');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(
        'AuthService: Sign in successful for ${userCredential.user?.email}',
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
        'AuthService: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}',
      );
      throw _handleAuthException(e);
    } catch (e) {
      print('AuthService: Unknown error - $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      print('AuthService: Attempting sign up for $email');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(
        'AuthService: Sign up successful for ${userCredential.user?.email}',
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
        'AuthService: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}',
      );
      throw _handleAuthException(e);
    } catch (e) {
      print('AuthService: Unknown error - $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    print('AuthService: Signing out user');
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      print('AuthService: Sending password reset email to $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('AuthService: Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      print(
        'AuthService: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}',
      );
      throw _handleAuthException(e);
    } catch (e) {
      print('AuthService: Unknown error - $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    print('AuthService: Handling exception code: ${e.code}');
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'Email/password sign in is not enabled. Please contact support.';
      default:
        return 'Authentication failed: ${e.message ?? e.code}';
    }
  }
}
