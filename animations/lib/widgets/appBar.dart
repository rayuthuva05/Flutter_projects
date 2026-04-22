import 'package:flutter/material.dart';

AppBar appBar() {
  return AppBar(
    title: Text(
      'Animations',
      style: TextStyle(shadows: [
        Shadow(
          color: Colors.black54,
          blurRadius: 5,
          offset: Offset(2, 3)
        )
      ]),
    ),
    centerTitle: true,
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
  );
}
