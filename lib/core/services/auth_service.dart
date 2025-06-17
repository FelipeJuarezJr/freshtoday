import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update the user's display name
      await credential.user?.updateDisplayName(username);
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _secureStorage.deleteAll(),
    ]);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Convert Firebase User to UserModel
  UserModel? getCurrentUserModel() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.uid,
      username: user.displayName ?? 'Anonymous',
      email: user.email ?? '',
      startDate: user.metadata.creationTime ?? DateTime.now(),
      profilePicture: user.photoURL,
      goals: [],
      preferences: {},
      currentStreak: 0,
      longestStreak: 0,
      achievements: [],
    );
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'email-already-in-use':
        return Exception('Email is already in use.');
      case 'invalid-email':
        return Exception('Email address is invalid.');
      case 'weak-password':
        return Exception('Password is too weak.');
      case 'operation-not-allowed':
        return Exception('Operation not allowed.');
      case 'account-exists-with-different-credential':
        return Exception('Account exists with different credentials.');
      case 'network-request-failed':
        return Exception('Network error occurred.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
} 