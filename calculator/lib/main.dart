import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double size = 0;

  String input = "";
  String calvalue = "";
  String operator = '';
  String display = '';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width / 5;
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(display,
                          style: TextStyle(fontSize: 30, color: Colors.black)),
                      margin: EdgeInsets.only(right: 40),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(input,
                          style: TextStyle(fontSize: 30, color: Colors.black)),
                      margin: EdgeInsets.only(right: 40),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      calButton("7", Colors.white38),
                      calButton("8", Colors.white38),
                      calButton("9", Colors.white38),
                      calButton("/", Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calButton("4", Colors.white38),
                      calButton("5", Colors.white38),
                      calButton("6", Colors.white38),
                      calButton("*", Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calButton("1", Colors.white38),
                      calButton("2", Colors.white38),
                      calButton("3", Colors.white38),
                      calButton("-", Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calButton(".", Colors.white38),
                      calButton("0", Colors.white38),
                      calButton("=", Colors.orange),
                      calButton("+", Colors.orange),
                    ],
                  )
                ],
              ),
              calButton("clear", Colors.red)
            ],
          )),
    );
  }

  Widget calButton(String text, Color bg) {
    return InkWell(
      onTap: () {
        if (text == "clear") {
          setState(() {
            input = "";
            calvalue = '';
            operator = '';
            display = '';
          });
        } else if (text == '.') {
          setState(() {
            if (input == '')
              input = "0" + text;
            else
              input = input + text;
          });
        } else if (text == '0') {
          setState(() {
            if (input != '') 
              input = input + text;
          });
        } else if (text == "+" || text == "-" || text == "*" || text == "/") {
          setState(() {
            calvalue = input;
            display = calvalue + text;
            input = '';

            operator = text;
          });
        } else if (text == "=") {
          setState(() {
            double cal = double.parse(calvalue);
            double inputvalue = double.parse(input);

            display = display + input;
            if (operator == '+') {
              input = (cal + inputvalue).toString();
            } else if (operator == '-') {
              input = (cal - inputvalue).toString();
            } else if (operator == '*') {
              input = (cal * inputvalue).toString();
            } else if (operator == '/') {
              input = (cal / inputvalue).toString();
            }
            display = '';
            //input = (double.parse(calvalue) + double.parse(input)).toString();
          });
        } else {
          setState(() {
            input = input + text;
          });
        }
      },
      child: Container(
          child:
              Text(text, style: TextStyle(fontSize: 26, color: Colors.white)),
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(100)),
          margin: EdgeInsets.all(10),
          height: size,
          width: size,
          alignment: Alignment(0, 0)),
    );
  }
}
