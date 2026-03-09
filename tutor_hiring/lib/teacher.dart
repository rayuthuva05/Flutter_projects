//import 'index.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatelessWidget {
  final List<String> items = [
    'John',
    'Smith',
    'Rose',
    'Alexa',
    'Iniyan',
    'Hari',
    'Thor',
    'Wick',
    'Thuva',
    'Rayu'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                "Hi, Tutor [user] welcome to e-Teacher.lk",
                style: TextStyle(fontSize: 20, color: Colors.amber),
              ),
            ),
            Text(
              "Find vacancies...",
              style: TextStyle(
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueAccent),
              softWrap: true,
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))))),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Card(
            //     elevation: 4, // Shadow depth
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('Imideiate vacancies',
            //               style: TextStyle(
            //                   fontSize: 20, fontWeight: FontWeight.bold)),
            //           SizedBox(height: 10),
            //           Text(
            //               'This is super plateform for teachers who interest to teaching online.'),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.blueAccent,
                      child: ListTile(
                        leading: Icon(Icons.work),
                        title: Text(items[index]),
                        subtitle: Text('Apply now to vacancy ${index + 1}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  } else {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.work),
                        title: Text(items[index]),
                        subtitle: Text('Apply now to vacancy ${index + 1}'),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                child: Text(
                  "Add your Profile",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                ),
                padding: EdgeInsets.only(left: 25),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ),
            ])
          ],
        ),
      ),
    );
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
