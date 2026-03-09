import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            //alignment: Alignment(0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),color: Colors.blue
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Container(
                child: Text('Thuva'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),color: Colors.orange
                ),
                padding: EdgeInsets.all(20),
              ),
              Container(
                child: Text('Thuva'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),color: Colors.orange
                ),
                padding: EdgeInsets.all(20),
              ),
              ]
            )
          ), 
        ),
      ),
    );
  }
}
