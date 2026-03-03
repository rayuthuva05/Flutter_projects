import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int noSemesters = 6;

  final semestersBox = Hive.box<SemesterModel>("semesters");

  List<SemesterModel> get semesters => semestersBox.values.toList();

  double get overallGpa {
    if (semesters.isEmpty) return 0.0;

    double total = 0;

    for (var sem in semesters) {
      total += sem.gpa;
    }

    return total / semesters.length;
  }

  void ConfirmDelete(index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete Semester"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel")
            ),
            ElevatedButton(
              onPressed: () async {
                final semestersBox= Hive.box<SemesterModel>("semesters");
                await semestersBox.deleteAt(index);
                Navigator.pop(context);
                setState(() {

                });
              },
              child: Text("Yes"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: fAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ValueListenableBuilder(
  valueListenable: Hive.box<SemesterModel>("semesters").listenable(),
  builder: (context, Box<SemesterModel> box, _) {
    final semesters = box.values.toList();

    // Recalculate overall GPA dynamically
    double overallGpa = 0;
    if (semesters.isNotEmpty) {
      double total = 0;
      for (var sem in semesters) total += sem.gpa;
      overallGpa = total / semesters.length;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // GPA Display
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("NO OF SEMESTERS", style: TextStyle(fontSize: 22, color: Colors.indigoAccent, fontWeight: FontWeight.w500)),
                  Text("${semesters.length}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 5, 63))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("OGPA", style: TextStyle(fontSize: 22, color: Colors.indigoAccent, fontWeight: FontWeight.w500)),
                  Text(overallGpa.toStringAsFixed(2), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 5, 63))),
                ],
              ),
            ],
          ),
        ),

        // Semester Cards
        Expanded(
          child: ListView.builder(
            itemCount: semesters.length,
            itemBuilder: (context, index) {
              final semester = semesters[index];
              return SemesterCard(
                year: semester.year,
                semester: semester.semester,
                gpa: semester.gpa,
                onDelete: () => ConfirmDelete(index),
              );
            },
          ),
        ),
      ],
    );
  },
)
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.calculate),
        SizedBox(width: 5),
        Text("GPA Calculator"),
      ],
    ),
    backgroundColor: const Color.fromARGB(255, 126, 5, 63),
    foregroundColor: Colors.white,
    shadowColor: Colors.grey,
    elevation: 5,
  );
}

FloatingActionButton fAB(BuildContext context) {
  return FloatingActionButton(
    onPressed: () async {
      await Navigator.pushNamed(context, '/add-semester');
    },
    foregroundColor: Colors.white,
    backgroundColor: const Color.fromARGB(255, 126, 5, 63),
    hoverColor: Colors.indigoAccent,
    child: Icon(Icons.add),
  );
}

class SemesterCard extends StatefulWidget {
  final int year;
  final int semester;
  final double gpa;
  final VoidCallback onDelete;

  const SemesterCard({
    super.key,
    required this.year,
    required this.semester,
    required this.gpa,
    required this.onDelete,
  });

  @override
  State<SemesterCard> createState() => _SemesterCardState();
}

class _SemesterCardState extends State<SemesterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(15),
      color: const Color.fromARGB(255, 236, 221, 171),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Year: ",
                          style: TextStyle(
                            fontSize: 24,
                            //color: const Color.fromARGB(255, 1, 51, 122),
                            color: const Color.fromARGB(255, 126, 5, 63),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${widget.year}st",
                          style: TextStyle(
                            fontSize: 20,
                            //color: const Color.fromARGB(255, 0, 0, 0),
                            color: const Color.fromARGB(255, 1, 51, 122),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester: ",
                          style: TextStyle(
                            fontSize: 24,
                            //color: const Color.fromARGB(255, 1, 51, 122),
                            color: const Color.fromARGB(255, 126, 5, 63),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${widget.semester}st",
                          style: TextStyle(
                            fontSize: 20,
                            //color: const Color.fromARGB(255, 0, 0, 0),
                            color: const Color.fromARGB(255, 1, 51, 122),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "GPA: ",
                          style: TextStyle(
                            fontSize: 24,
                            //color: const Color.fromARGB(255, 1, 51, 122),
                            color: const Color.fromARGB(255, 126, 5, 63),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.gpa.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 32, 145, 58),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/edit-semester");
                  },
                  icon: Icon(
                    Icons.edit,
                    color: const Color.fromARGB(255, 12, 11, 18),
                  ),
                ),
                SizedBox(width: 30),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
