import 'package:flutter/material.dart';
import 'home.dart';
import 'jobs.dart';
import 'about.dart';
import 'seeker.dart';
import 'signup.dart';
import 'login.dart';
import 'contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saha Holdings',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/home': (context) => HomePage(),
        '/jobs': (context) => JobsPage(),
        '/about': (context) => AboutPage(),
        '/seeker': (context) => SeekerPage(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => SignInPage(),
        '/contact': (context) => ContactPage()
      },
    );
  }
}
