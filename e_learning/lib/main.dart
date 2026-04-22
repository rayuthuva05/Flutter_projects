import 'package:e_learning/screens/home_page.dart';
import 'package:e_learning/screens/login_page.dart';
import 'package:e_learning/screens/student_dashboard.dart';
import 'package:e_learning/screens/teacher_dashboard.dart';
import 'package:e_learning/screens/twoD_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ELearningApp());
}

class ELearningApp extends StatelessWidget {
  const ELearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-learning',
      routes: {
        '/': (context) => LoginPage(),
        'home': (context) => HomePage(),
        '/teacher': (context) => TeacherDashboard(),
        '/student': (context) => StudentDashboard(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(cardColor: const Color.fromARGB(255, 215, 207, 178)),
    );
  }
}

class TwoDApp extends StatelessWidget {
  TwoDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('2DView'), centerTitle: true),
        body: TwoDimensionalGridView(
          delegate: TwoDimensionalChildBuilderDelegate(
            maxXIndex: 9,
            maxYIndex: 9,
            builder: (BuildContext context, ChildVicinity vicinity) {
              return Container(
                color: vicinity.xIndex.isEven && vicinity.yIndex.isOdd
                    ? Colors.amberAccent.shade200
                    : vicinity.xIndex.isOdd && vicinity.yIndex.isEven
                    ? Colors.purple
                    : null,
                height: 200,
                width: 200,
                child: Center(
                  child: Text(
                    'Row ${vicinity.yIndex} : Column ${vicinity.xIndex}',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
