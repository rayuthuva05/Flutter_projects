import 'package:flutter/material.dart';

void main() {
  List<String> fr = ['apple', 'mango', 'banana'];
  runApp(MaterialApp(
    home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Listview builder",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: fr.length,
            itemBuilder: (context, index) {
              // return Text("hello");
              // return Text("Hello" + index.toString());
              return Text(fr[index]);
            })),
  ));
}
