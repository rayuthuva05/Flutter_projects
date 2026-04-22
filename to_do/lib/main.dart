import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String data = "No text Data";
  List<String> task = ['task1', 'task2'];
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            centerTitle: true,
            title: Text(
              "To-Do-App",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreenAccent),
            ),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  label: Text("Enter a task",
                                      style: TextStyle(color: Colors.grey)))))),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: MaterialButton(
                        color: Colors.deepOrangeAccent,
                        child: Text("Click",
                            style: TextStyle(color: Colors.white)),
                        hoverColor: Colors.lightGreen,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          setState(() {
                            task.add(textController.text);
                            textController.clear();
                          });
                        }),
                  )
                ],
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: task.length,
                    itemBuilder: (context, index) {
                      return Row(children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Text(task[index]),
                          ),
                        ),
                        MaterialButton(
                            hoverColor: Colors.white10,
                            child: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                task.removeAt(index);
                              });
                            })
                      ]);
                    }),
              )
            ],
          )),
    );
  }
}
