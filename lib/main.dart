import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/sobriety_service.dart';
import 'core/services/auth_service.dart';
import 'data/providers/sobriety_provider.dart';
import 'data/providers/auth_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
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
          create: (_) => AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
          update: (context, service, previous) =>
              previous ?? AuthProvider(service),
        ),
        Provider<SobrietyService>(
          create: (_) => SobrietyService(prefs),
        ),
        ChangeNotifierProxyProvider<SobrietyService, SobrietyProvider>(
          create: (context) => SobrietyProvider(context.read<SobrietyService>()),
          update: (context, service, previous) =>
              previous ?? SobrietyProvider(service),
        ),
      ],
      child: MaterialApp(
        title: 'FreshToday',
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
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return authProvider.isAuthenticated
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
