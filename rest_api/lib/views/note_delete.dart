import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  const NoteDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Are you sure you want delete?'),
      actions: [_buildButton('No', context), _buildButton('Yes', context)],
    );
  }

  Widget _buildButton(String type, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (type == 'Yes') {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pop(false);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: type == 'Yes' ? Colors.red : Colors.white,
        foregroundColor: type == 'Yes' ? Colors.white : Colors.black,
      ),
      child: Text(type),
    );
  }
}
