import 'package:flutter/material.dart';
import 'package:sliderview/loading_screen.dart';
import 'package:sliderview/payouts.dart';
import 'package:sliderview/radial_menu.dart';
import 'package:sliderview/slider.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoadingScreen(),
        'slide': (context) => SliderView(),
        'radial-menu': (context) => RadialMenuApp(),
        'pay-outs': (context) => PayoutsApp()
      },
    );
  }
}

