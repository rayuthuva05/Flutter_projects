import 'package:flutter/material.dart';

class VacantPage extends StatefulWidget {
  @override
  State<VacantPage> createState() => _VacantPageState();
}

class _VacantPageState extends State<VacantPage> {
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
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "Please provide accurate data.",
                    style: TextStyle(fontSize: 20, color: Colors.redAccent),
                  ),
                ),
                Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Form(
                        child: Column(
                      children: [
                        Container(
                          child: Text(
                            'Filling Form',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          margin: EdgeInsets.all(20),
                        ),
                        Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              label: Text('Enter Full name',
                                  style: TextStyle(color: Colors.black38)),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: 350,
                          height: 50,
                          margin: EdgeInsets.all(20),
                        ),
                        Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              label: Text('Enter Location',
                                  style: TextStyle(color: Colors.black38)),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: 350,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              label: Text('Enter Phone Number',
                                  style: TextStyle(color: Colors.black38)),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: 350,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          child: TextField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              label: Text('Enter Description',
                                  style: TextStyle(color: Colors.black38)),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          width: 350,
                          height: 100,
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: MaterialButton(
                            onPressed: () {
                              ShowDialogBox(context);
                            },
                            child: Text(
                              'Publish',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            color: const Color.fromARGB(255, 25, 8, 240),
                            hoverColor:
                                const Color.fromARGB(255, 231, 234, 231),
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    )))
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

  void ShowDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                TextButton(
                  onPressed: () {},
                  child: Text("confirm to publish"),
                )
              ],
              title: Text('Make sure to publish your content'),
              contentPadding: EdgeInsets.all(20),
            ));
  }
}
