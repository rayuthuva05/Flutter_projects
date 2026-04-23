import 'package:flutter/material.dart';

class NoteModify extends StatelessWidget {
  const NoteModify({super.key});

  @override
  Widget build(BuildContext context) {
    final noteID = ModalRoute.of(context)!.settings.arguments as String?;
    final bool isEditing = noteID== null;

    return Scaffold(
      appBar: AppBar(title: Text(
        isEditing
        ? 'Create note' 
        : 'Edit note'
      )),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextField('Enter Title'),
            SizedBox(height: 20),
            _buildTextField('Enter Content'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  //api-update
                } else {
                  //create-api
                }
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      style: TextStyle(color: Colors.blueAccent),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.blueGrey,
        focusColor: Colors.blueAccent,
        hoverColor: Colors.blueAccent,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
