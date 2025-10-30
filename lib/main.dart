import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/post_provider.dart';
import 'screens/listing_screen.dart';
import 'screens/detail_screen.dart';
import 'models/post_model.dart';

void main() {
  runApp(const OraxApp());
}

class OraxApp extends StatelessWidget {
  const OraxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // App theme tuned to match the provided design colors & fonts
    final baseTheme = ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF3F8FB),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => PostProvider()..loadPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Orax Internship Assignment',
        theme: baseTheme,
        initialRoute: '/',
        routes: {
          '/': (_) => const ListingScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final args = settings.arguments as Post;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(post: args),
            );
          }
          return null;
        },
      ),
    );
  }
}
