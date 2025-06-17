import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    _init();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _init() {
    _authService.authStateChanges.listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _user = _authService.getCurrentUserModel();
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);
      _user = _authService.getCurrentUserModel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.registerWithEmailAndPassword(email, password, username);
      _user = _authService.getCurrentUserModel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signInWithGoogle();
      _user = _authService.getCurrentUserModel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signOut();
      _user = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.resetPassword(email);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      _user = _authService.getCurrentUserModel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 