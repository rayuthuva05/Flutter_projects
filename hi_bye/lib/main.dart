import 'package:flutter/material.dart';

void main() {
  runApp(SecondApp());
}

class SecondApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SecondAppState();
  }
}

class SecondAppState extends State<SecondApp> {
  String name = "Hi";
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Change hi to bye"),
        ),
        body: Column(
          children: [
            Text(name),
            MaterialButton(
              onPressed: () {
                setState(() {
                  name = "Bye";
                });
              },
              child: Text("Click"),
              color: Colors.blue,
              hoverColor: Colors.green,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    ));
  }
}
