import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepOrangeAccent,
              title: Text(
                "SignUp",
                style: TextStyle(color: Colors.lightGreenAccent),
              ),
              centerTitle: true,
            ),
            body: Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Container(
                    child: TextFormField(),
                  )
                ],
              ),
            ))));
  }
}
