import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "e-Teacher.lk",
                    style:
                        TextStyle(color: const Color.fromARGB(255, 99, 98, 95)),
                  )),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: login(),
              ),
              Container(
                child: register(),
              )
            ]),
          ]),
          backgroundColor: const Color.fromARGB(255, 25, 8, 214),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                menuList(),
                Text('Start your path with Us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 204, 200, 200),
                        shadows: [
                          Shadow(
                              color: Colors.cyan,
                              offset: Offset(3, 3),
                              blurRadius: 3)
                        ])),
              ],
            ),
            Divider(
              color: Colors.blueAccent,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: Text('Tutor'),
                          hoverColor: Colors.cyan,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text('Learner'),
                          hoverColor: Colors.cyan,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(134, 233, 231, 231)),
                  )
                ],
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            RowConent('Tutoring', 'Learnings'),
            RowConent('Exams', 'Practicals'),
          ],
        ),
      ),
    ));
  }

  Widget login() {
    return Container(
        child: MaterialButton(
      onPressed: () {},
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.lightGreen,
    ));
  }

  Widget register() {
    return Container(
        child: MaterialButton(
      onPressed: () {},
      child: Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.lightGreen,
    ));
  }

  Widget Content(String feature) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            feature,
            style: TextStyle(fontSize: 24),
          ),
          decoration: BoxDecoration(
              color: const Color.fromARGB(134, 233, 231, 231),
              borderRadius: BorderRadius.circular(10)),
          width: 200,
          height: 200,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
        )
      ],
    );
  }

  Widget RowConent(String service1, String service2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            service1,
            style: TextStyle(fontSize: 24),
          ),
          decoration: BoxDecoration(
              color: const Color.fromARGB(134, 233, 231, 231),
              borderRadius: BorderRadius.circular(10)),
          width: 150,
          height: 150,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(20),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            service2,
            style: TextStyle(fontSize: 24),
          ),
          decoration: BoxDecoration(
              color: const Color.fromARGB(134, 233, 231, 231),
              borderRadius: BorderRadius.circular(10)),
          width: 150,
          height: 150,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
        )
      ],
    );
  }

  Widget menuList() {
    return Container(
      child: Icon(
        Icons.list,
        size: 40,
        color: Colors.blue,
      ),
    );
  }
}
