import 'package:flutter/material.dart';
import 'package:gpa_calculator/models/semester_model.dart';
import 'package:gpa_calculator/models/subject_model.dart';
import 'package:hive/hive.dart';

class AddSemester extends StatefulWidget {
  const AddSemester({super.key});

  @override
  State<AddSemester> createState() => _AddSemesterState();
}

class _AddSemesterState extends State<AddSemester> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _semesterController = TextEditingController();

  List<Map<String, TextEditingController>> subjects = [];

  @override
  void initState() {
    super.initState();
    addSubjectField();
  }

  void addSubjectField() {
    setState(() {
      subjects.add({
        "subject_code": TextEditingController(),
        "grade": TextEditingController(),
      });
    });
  }

  void submitForm() async{
    if ((_formKey.currentState?.validate() ?? false) && subjects.isNotEmpty) {
      final year = int.parse(_yearController.text);
      final semester = int.parse(_semesterController.text);

      List<SubjectModel> subjectList = subjects.map((subject) {
        return SubjectModel(
          subjectCode: subject['subject_code']!.text,
          grade: subject['grade']!.text,
        );
      }).toList();

      final newSemester = SemesterModel(
        year: year,
        semester: semester,
        subjects: subjectList,
      );

      final semestersBox = Hive.box<SemesterModel>("semesters");
      await semestersBox.add(newSemester);
      Navigator.pop(context);
    }

    final year = int.parse(_yearController.text);
    final semester = int.parse(_semesterController.text);

    print("year: $year \t semester: $semester");

    
  }

  @override
  void dispose() {
    _yearController.dispose();
    _semesterController.dispose();

    for (var subject in subjects) {
      subject['subject_code']?.dispose();
      subject['grade']?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    hintText: 'Enter year',
                    hintStyle: TextStyle(fontSize: 20),
                    labelText: 'Year',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _semesterController,
                  decoration: InputDecoration(
                    hintText: 'Enter Semester',
                    hintStyle: TextStyle(fontSize: 20),
                    labelText: 'Semester',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ...subjects.map((subject) {
                  return Column(
                    children: [
                      TextField(
                        controller: subject['subject_code'],
                        decoration: InputDecoration(
                          hintText: 'Enter Subject code',
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: 'Subject code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: subject['grade'],
                        decoration: InputDecoration(
                          hintText: 'Enter Grade',
                          hintStyle: TextStyle(fontSize: 20),
                          labelText: 'Grade',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add more subjects",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    IconButton.filled(
                      onPressed: addSubjectField,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => submitForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Add'),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text("Add Semester"),
    backgroundColor: const Color.fromARGB(255, 126, 5, 63),
    foregroundColor: Colors.white,
    shadowColor: Colors.grey,
    elevation: 5,
  );
}
