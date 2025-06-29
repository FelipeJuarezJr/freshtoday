import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isLogin) {
          await context.read<AppAuthProvider>().signInWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text,
              );
        } else {
          await context.read<AppAuthProvider>().registerWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text,
                _emailController.text.split('@')[0], // Use email username as display name
              );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await context.read<AppAuthProvider>().signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'FreshToday',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!_isLogin && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (_emailController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter your email to reset password'),
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  await context.read<AppAuthProvider>().resetPassword(_emailController.text.trim());
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Password reset email sent!'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _submitForm,
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isLogin ? 'Sign In' : 'Register'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        context.read<AppAuthProvider>().clearError();
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Don\'t have an account? Register'
                          : 'Already have an account? Sign In',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: authProvider.isLoading ? null : _signInWithGoogle,
                    icon: Image.network(
                      'https://www.google.com/favicon.ico',
                      height: 24,
                    ),
                    label: const Text('Continue with Google'),
                  ),
                  const SizedBox(height: 16),
                  // Debug button for troubleshooting
                  TextButton(
                    onPressed: () {
                      final firebaseUser = FirebaseAuth.instance.currentUser;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Debug Info'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AuthProvider isLoading: ${authProvider.isLoading}'),
                              Text('AuthProvider isAuthenticated: ${authProvider.isAuthenticated}'),
                              Text('AuthProvider user: ${authProvider.user?.username ?? 'null'}'),
                              Text('AuthProvider error: ${authProvider.error ?? 'null'}'),
                              const SizedBox(height: 8),
                              Text('Firebase currentUser: ${firebaseUser?.uid ?? 'null'}'),
                              Text('Firebase email: ${firebaseUser?.email ?? 'null'}'),
                              Text('Firebase displayName: ${firebaseUser?.displayName ?? 'null'}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('🔍 Debug Info'),
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to terms and conditions
                      },
                      child: const Text(
                        'By registering, you agree to our Terms and Conditions',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 