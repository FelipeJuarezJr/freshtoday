import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';

class AppAuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AppAuthProvider(this._authService) {
    _init();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _init() {
    try {
      print('AuthProvider: Initializing auth state listener...');
      _authService.authStateChanges.listen(
        (User? firebaseUser) {
          try {
            print('AuthProvider: Auth state changed, user: ${firebaseUser?.uid ?? 'null'}');
            print('AuthProvider: Previous user: ${_user?.username ?? 'null'}');
            if (firebaseUser != null) {
              _user = _authService.getCurrentUserModel();
              print('AuthProvider: User model created: ${_user?.username}');
              print('AuthProvider: isAuthenticated will be: true');
            } else {
              _user = null;
              print('AuthProvider: User set to null');
              print('AuthProvider: isAuthenticated will be: false');
            }
            print('AuthProvider: Notifying listeners...');
            notifyListeners();
            print('AuthProvider: Listeners notified');
          } catch (e) {
            print('AuthProvider: Error in auth state listener: $e');
            _user = null;
            notifyListeners();
          }
        },
        onError: (error) {
          print('AuthProvider: Error in auth state stream: $error');
          _user = null;
          notifyListeners();
        },
      );
      print('AuthProvider: Auth state listener initialized successfully');
    } catch (e) {
      print('AuthProvider: Error initializing auth state listener: $e');
      _user = null;
      notifyListeners();
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('AuthProvider: Starting email/password sign in...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);
      print('AuthProvider: Email/password sign in completed successfully');
      // Remove manual user setting - let the auth state listener handle it
      // _user = _authService.getCurrentUserModel();

      _isLoading = false;
      notifyListeners();
      print('AuthProvider: Email/password sign in - loading set to false');
    } catch (e) {
      print('AuthProvider: Email/password sign in failed: $e');
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