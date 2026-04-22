import 'package:codex_project/widgets/card_back.dart';
import 'package:codex_project/widgets/card_front.dart';
import 'package:flutter/material.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  double _rotationFactor = 0;
  final pi = 3.14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cards'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * _rotationFactor),
              origin: Offset(MediaQuery.of(context).size.width / 2, 0),
              child: _rotationFactor<0.5 ? CardFrontView() : CardBackView(),
            ),
            Slider(
              value: _rotationFactor,
              onChanged: (double value) {
                setState(() {
                  _rotationFactor = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  
}
