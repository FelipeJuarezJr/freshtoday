import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/services/sobriety_service.dart';
import 'core/services/auth_service.dart';
import 'data/providers/sobriety_provider.dart';
import 'data/providers/auth_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Starting FreshToday app...');
  
  // Initialize SharedPreferences first
  SharedPreferences prefs;
  try {
    print('Initializing SharedPreferences...');
    prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized successfully');
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
    prefs = await SharedPreferences.getInstance();
  }
  
  // Initialize Firebase with comprehensive error handling
  try {
    print('Initializing Firebase...');
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } else {
      Firebase.app();
      print('Firebase already initialized, using existing instance');
    }
    
    // Test Firebase auth
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Firebase current user on startup: ${currentUser?.uid ?? 'null'}');
    print('Firebase current user email: ${currentUser?.email ?? 'null'}');
    
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for now
  }
  
  // Initialize notifications with error handling
  try {
    print('Initializing notifications...');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Notifications initialized successfully');
  } catch (e) {
    print('Error initializing notifications: $e');
  }
  
  print('All initializations complete, running app...');
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) {
            try {
              print('Creating AuthService...');
              return AuthService();
            } catch (e) {
              print('Error creating AuthService: $e');
              rethrow;
            }
          },
        ),
        ChangeNotifierProxyProvider<AuthService, AppAuthProvider>(
          create: (context) {
            try {
              print('Creating AppAuthProvider...');
              return AppAuthProvider(context.read<AuthService>());
            } catch (e) {
              print('Error creating AppAuthProvider: $e');
              rethrow;
            }
          },
          update: (context, service, previous) {
            try {
              return previous ?? AppAuthProvider(service);
            } catch (e) {
              print('Error updating AppAuthProvider: $e');
              rethrow;
            }
          },
        ),
        Provider<SobrietyService>(
          create: (_) {
            try {
              print('Creating SobrietyService...');
              return SobrietyService(prefs);
            } catch (e) {
              print('Error creating SobrietyService: $e');
              rethrow;
            }
          },
        ),
        ChangeNotifierProxyProvider<SobrietyService, SobrietyProvider>(
          create: (context) {
            try {
              print('Creating SobrietyProvider...');
              return SobrietyProvider(context.read<SobrietyService>());
            } catch (e) {
              print('Error creating SobrietyProvider: $e');
              rethrow;
            }
          },
          update: (context, service, previous) {
            try {
              return previous ?? SobrietyProvider(service);
            } catch (e) {
              print('Error updating SobrietyProvider: $e');
              rethrow;
            }
          },
        ),
      ],
      child: MaterialApp(
        title: 'FreshToday',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: Consumer<AppAuthProvider>(
          builder: (context, authProvider, _) {
            print('=== MAIN NAVIGATION DEBUG ===');
            print('Building home screen, authProvider.isLoading: ${authProvider.isLoading}');
            print('Building home screen, authProvider.isAuthenticated: ${authProvider.isAuthenticated}');
            print('Building home screen, authProvider.user: ${authProvider.user?.username ?? 'null'}');
            print('Building home screen, authProvider.user?.id: ${authProvider.user?.id ?? 'null'}');
            print('Building home screen, authProvider.error: ${authProvider.error ?? 'null'}');
            
            // Add Firebase current user check
            try {
              final firebaseUser = FirebaseAuth.instance.currentUser;
              print('Firebase current user: ${firebaseUser?.uid ?? 'null'}');
              print('Firebase current user email: ${firebaseUser?.email ?? 'null'}');
              print('Firebase current user displayName: ${firebaseUser?.displayName ?? 'null'}');
            } catch (e) {
              print('Error getting Firebase current user: $e');
            }
            print('=== END NAVIGATION DEBUG ===');
            
            if (authProvider.isLoading) {
              print('Showing loading screen...');
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (authProvider.isAuthenticated) {
              print('User is authenticated, showing HomeScreen...');
              return const HomeScreen();
            } else {
              print('User is not authenticated, showing LoginScreen...');
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreshToday Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'App is running successfully!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'If you can see this, the basic setup is working.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Info'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<AppAuthProvider>(
        builder: (context, authProvider, _) {
          final firebaseUser = FirebaseAuth.instance.currentUser;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Authentication Debug Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // AuthProvider State
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AuthProvider State:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('isLoading: ${authProvider.isLoading}'),
                        Text('isAuthenticated: ${authProvider.isAuthenticated}'),
                        Text('user: ${authProvider.user?.username ?? 'null'}'),
                        Text('user ID: ${authProvider.user?.id ?? 'null'}'),
                        Text('error: ${authProvider.error ?? 'null'}'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Firebase State
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Firebase State:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('currentUser: ${firebaseUser?.uid ?? 'null'}'),
                        Text('email: ${firebaseUser?.email ?? 'null'}'),
                        Text('displayName: ${firebaseUser?.displayName ?? 'null'}'),
                        Text('emailVerified: ${firebaseUser?.emailVerified ?? 'null'}'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text('Go to Login Screen'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          },
                          child: const Text('Go to Home Screen'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Signed out from Firebase')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error signing out: $e')),
                              );
                            }
                          },
                          child: const Text('Sign Out from Firebase'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
