import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_4/pages/home.dart';
import 'package:quiz_4/pages/log_in.dart';
import 'package:quiz_4/pages/sign_up.dart';
import 'package:quiz_4/services/auth.dart';
import 'package:quiz_4/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
  await setupSupabase();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  MyApp({super.key}) {
    _authService = _getIt.get<AuthService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 96, 87)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 73, 155, 151),
          displayColor: Colors.white,
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 166, 198, 192),
      ),
      initialRoute: _authService.user != null ? '/home' : '/login',
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const RegisterUser(),
        '/home': (context) => const HomeRoute()
      },
    );
  }
}
