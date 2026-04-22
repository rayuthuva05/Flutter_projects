import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RunNewData extends StatefulWidget {
  const RunNewData({super.key});

  @override
  State<RunNewData> createState() => _RunNewDataState();
}

class _RunNewDataState extends State<RunNewData> {
  String? selectedFile;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'npy', 'json'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 209, 96),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber),
                      SizedBox(width: 20),
                      Text(
                        'Note : ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Please note that you must input data as matrices format. You don\'t allow input MRI Image.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              shadowColor: Colors.black54,
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  // key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Subject ID',
                          labelText: 'Subject ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: pickFile,
                        label: const Text('Select data File'),
                        icon: const Icon(Icons.file_open),
                      ),
                      SizedBox(height: 20),
                      Text(
                        selectedFile ?? 'No file selected!',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: selectedFile != null
                                ? () {
                                    Navigator.pop(context, selectedFile);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Model run successfully!.',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 5),
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Test'),
                          ),
                          SizedBox(width: 20),
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
          ],
        ),
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text(
      'Test New Input Data to classification',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    backgroundColor: const Color.fromARGB(255, 118, 141, 151),
    shadowColor: Colors.black54,
    elevation: 5,
    actionsPadding: EdgeInsets.only(right: 20),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
