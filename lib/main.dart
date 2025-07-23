import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/firebase_options.dart';
import 'package:flutter_task/screens/auth_screen.dart';
import 'package:flutter_task/screens/file_preview_screen.dart';
import 'package:flutter_task/screens/home_screen.dart';
import 'package:flutter_task/screens/landing_screen.dart';
import 'package:flutter_task/models/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Flutter Task - Sheik',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.poppinsTextTheme()),
        // home: const AuthScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/file-preview': (context) => FilePreviewScreen(
                url: ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
