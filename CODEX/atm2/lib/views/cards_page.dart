import 'package:codex_project/widgets/card_back.dart';
import 'package:codex_project/widgets/card_front.dart';
import 'package:flutter/material.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final pi = 3.14;
  final int _rotationFactor = 0;
  late TextEditingController _cardNumberController;
  late TextEditingController _cvvNumberController;
  String _cardNumber = '';
  String _cvvNumber = '';

  @override
  _CardsPageState() {
    _cardNumberController = TextEditingController();
    _cvvNumberController = TextEditingController();

    _cardNumberController.addListener(() {
      _cardNumber = _cardNumberController.text;
      setState(() {});
    });

    _cvvNumberController.addListener(() {
      _cvvNumber = _cvvNumberController.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cards'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * _rotationFactor),
              origin: Offset(MediaQuery.of(context).size.width / 2, 0),
              child: _rotationFactor < 0.5
                  ? CardFrontView(cardNumber: _cardNumber)
                  : CardBackView(cvvNumber: _cvvNumber,),
            ),
            Slider(value: value, onChanged: onChanged),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Card Number'),
                    controller: _cardNumberController,
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Name on Card'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Expiry Date'),
                        ),
                      ),
                      SizedBox(width: 32),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          decoration: InputDecoration(hintText: 'CVV'),
                          keyboardType: TextInputType.number,
                          controller: _cvvNumberController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
