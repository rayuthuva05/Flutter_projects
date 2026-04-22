import 'package:flutter/material.dart';

class LearnerPage extends StatelessWidget {
  final teacher = ['john', 'wick', 'kamal', 'Thuva', 'Rayu'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "e-Teacher.lk",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Home(),
                      ),
                      Container(
                        child: logout(),
                      )
                    ]),
                  ]),
              backgroundColor: const Color.fromARGB(255, 25, 8, 214),
            ),
            body: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Hi, [user] welcome to e-Teacher.lk",
                    style: TextStyle(fontSize: 20, color: Colors.amber),
                  ),
                ),
                Text(
                  "Find our best teachers...",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.blueAccent,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                ),
                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: teacher.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(teacher[index],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                                 SizedBox(height: 10),
                                        FloatingActionButton(
                                          onPressed: () {},
                                          child: Text("See Profile",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          backgroundColor: Colors.blueAccent,
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Image(
                                          image: AssetImage('teacher.png')),
                                      margin: EdgeInsets.all(10),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.bottomRight,
                                      child: FloatingActionButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Hire',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        })),
                Container(
                  child: FloatingActionButton.small(
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  alignment: Alignment.bottomRight,
                )
              ],
            )));
  }

  Widget Home() {
    return Container(
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightGreen,
      ),
    );
  }

  Widget logout() {
    return Container(
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.lightGreen,
      ),
    );
  }
}
