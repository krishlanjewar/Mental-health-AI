import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/navigation/presentation/pages/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8DBDBA),
          primary: const Color(0xFF8DBDBA),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
