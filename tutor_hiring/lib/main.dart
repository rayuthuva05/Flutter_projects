import 'package:flutter/material.dart';
import 'package:tutor_hiring/teacher.dart';
import 'login.dart';
import 'index.dart';
import 'register.dart';
import 'learner.dart';
import 'teacher.dart';
import 'student_vacant.dart';
import 'tutor_payment.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Teacher.lk',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PaymentPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/teacher': (context) => TeacherPage(),
        '/learner': (context) => LearnerPage(),
        '/Vacancy': (context) => VacantPage(),
        '/payment': (context) => PaymentPage(),
      },
    );
  }
}
