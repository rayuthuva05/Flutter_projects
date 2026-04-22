import 'package:brain_imaging_analyzer/models/prediction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:dio/dio.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final predictionBox = Hive.box<PredictionModel>("predictions");

  @override
  Widget build(BuildContext context) {
    final predictions = predictionBox.values.toList();
    return ResultsPage(data: predictions);
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.data});

  final List<PredictionModel> data;
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final predictionBox = Hive.box<PredictionModel>("predictions");

  List<PredictionModel> outputs = [];
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    outputs = predictionBox.values.toList();
  }

  void searchSubjects(String query) {
    final predictions = Hive.box<PredictionModel>("predictions");

    if (query.isEmpty) {
      setState(() {
        outputs = predictions.values.toList();
      });
      return;
    }

    final subjects = predictions.values.where((subject) {
      final subjectId = subject.subjectId.toLowerCase();
      final subjectType = subject.subjectType.toLowerCase();
      final input = query.toLowerCase();

      return subjectId.contains(input) || subjectType.contains(input);
    }).toList();

    setState(() => outputs = subjects);
  }

  void sortBy() {
    if (_dropdownValue == null) return;

    setState(() {
      switch (_dropdownValue) {
        case 'newest':
          outputs.sort((a, b) => b.date.compareTo(a.date));
          break;
        case 'oldest':
          outputs.sort((a, b) => a.date.compareTo(b.date));
          break;
        case 'asd':
          outputs.sort((a, b) {
            if (a.subjectType.toLowerCase() == 'asd' &&
                b.subjectType.toLowerCase() != 'asd')
              return -1;
            if (a.subjectType.toLowerCase() != 'asd' &&
                b.subjectType.toLowerCase() == 'asd')
              return 1;
            return 0;
          });
          break;
        case 'hc':
          outputs.sort((a, b) {
            if (a.subjectType.toLowerCase() == 'hc' &&
                b.subjectType.toLowerCase() != 'hc')
              return -1;
            if (a.subjectType.toLowerCase() != 'hc' &&
                b.subjectType.toLowerCase() == 'hc')
              return 1;
            return 0;
          });
        default:
          outputs.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
        sortBy();
      });
    }
  }

  final Dio dio = Dio();

  Future<void> downloadFile(PredictionModel item) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                "Prediction results of ${item.subjectId}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 30),
              pw.Text("Subject Type: ${item.subjectType}"),
              pw.Text(
                "Check Date: ${item.date.day}/${item.date.month}/${item.date.year}",
              ),
              pw.Text(
                "Prediction: ${item.prediction}",
                style: pw.TextStyle(fontItalic: pw.Font.timesItalic()),
              ),
              pw.Text("Confidence: ${item.confidence}"),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory("${dir.path}/Bimage");

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final file = File("${folder.path}/${item.subjectId}_result.pdf");

    await file.writeAsBytes(await pdf.save());

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pdf saved: ${file.path}"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 50,
          title: Text(
            'Output of new data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[350],
          foregroundColor: const Color.fromARGB(255, 37, 9, 113),
          actions: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: SearchBar(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 8),
                    ),
                    leading: const Icon(Icons.search),
                    hintText: 'Search...',
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 37, 9, 113),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    elevation: WidgetStatePropertyAll(5.0),
                    overlayColor: WidgetStatePropertyAll(
                      const Color.fromARGB(255, 248, 243, 226),
                    ),
                    onChanged: searchSubjects,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueGrey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text(
                        "Sort",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "newest",
                          child: Text(
                            "Newest first",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 45, 44, 44),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "oldest",
                          child: Text(
                            "Oldest first",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 45, 44, 44),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "asd",
                          child: Text(
                            "Atiusm first",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 45, 44, 44),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "hc",
                          child: Text(
                            "HC first",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 45, 44, 44),
                            ),
                          ),
                        ),
                      ],
                      onChanged: dropdownCallback,
                      value: _dropdownValue,
                      icon: Icon(Icons.sort_outlined),
                      iconSize: 15,
                      dropdownColor: const Color.fromARGB(255, 246, 236, 208),
                      dropdownMenuItemMouseCursor: SystemMouseCursors.click,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
          actionsPadding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        ValueListenableBuilder(
          valueListenable: predictionBox.listenable(),
          builder: (context, Box<PredictionModel> box, _) {
            if (outputs.isEmpty) outputs = predictionBox.values.toList();
            final data = outputs;

            return SliverGrid.count(
              crossAxisCount: 4,
              childAspectRatio: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(data.length, (index) {
                final item = data[index];

                Color gridColor = item.prediction == item.subjectType
                    ? Colors.green.shade400
                    : Colors.red.shade400;

                Color fontColor = item.prediction == item.subjectType
                    ? Colors.white
                    : Colors.blueGrey.shade100;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Prediction Result",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 100),
                                IconButton(
                                  icon: Icon(Icons.download_rounded),
                                  onPressed: () {
                                    downloadFile(item);
                                  },
                                ),
                              ],
                            ),
                            content: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'SubjectId: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${item.subjectId}\n',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const TextSpan(
                                    text: 'SubjectType: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${item.subjectType}\n',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const TextSpan(
                                    text: 'Date: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${item.date.day}/${item.date.month}/${item.date.year}\n',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const TextSpan(
                                    text:
                                        "\nThe model predicts that this subject belongs to ",
                                  ),
                                  TextSpan(
                                    text: item.prediction,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "\ngroup with a confidence score of ",
                                  ),
                                  TextSpan(
                                    text: "${item.confidence}%",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: "."),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Confirm Delete"),
                                          content: Text(
                                            "Are you sure you want to delete subject ${item.subjectId}?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                box.deleteAt(index);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ItemWidget(
                      text:
                          "SubjectId: ${item.subjectId}\n"
                          "SubjectType: ${item.subjectType}",
                      gridColor: gridColor,
                      fontColor: fontColor,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
    required this.gridColor,
    required this.fontColor,
  });

  final String text;
  final Color gridColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black54,
      elevation: 6,
      color: gridColor,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
