import 'package:brain_imaging_analyzer/models/prediction_model.dart';
import 'package:brain_imaging_analyzer/screens/analytics_screen.dart';
import 'package:brain_imaging_analyzer/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newDataBox = Hive.box<PredictionModel>("predictions");

  void getData() async {
    final newData =
        await Navigator.pushNamed(context, 'run-newData')
            as Map<String, dynamic>?;

    if (newData != null) {
      PredictionModel model = PredictionModel(
        subjectId: newData['subjectId'],
        subjectType: newData['subjectType'],
        prediction: newData['prediction'],
        confidence: newData['confidence'],
        filepath: newData['filepath'],
        date: newData['date'],
      );

      newDataBox.add(model);
      //print(newDataBox.values.toList());
      //print("Data: $newData");
      setState(() {});
    }
  }

  FloatingActionButton fAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: getData,
      icon: Icon(Icons.electric_bolt, color: Colors.amber),
      label: Text('Run with XAI', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBar(),
        floatingActionButton: fAB(context),
        body: TabBarView(
          children: [
            Tab(child: workflowTab()),
            Tab(child: analyticalTab()),
            Tab(child: resultsTab()),
          ],
        ),
      ),
    );
  }
}

Widget workflowTab() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        workflowContent(title: 'Data Collection', point: 'Data collection is first step of research.'),
        SizedBox(height: 20),
        Image(image: AssetImage('assets/images/Picture1.png')),
      ],
    ),
  );
}

Widget workflowContent({
  required String title,
  required String point
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      workflowTitle(title: title),
      Divider(),
      workflowPoint(point: point),
    ],
  );
}

Widget workflowTitle({required String title}) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 37, 9, 113),
    ),
  );
}

Widget workflowPoint({required String point}) {
  return Text(
    point,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
  );
}

Widget analyticalTab() {
  return AnalyticsScreen();
}

Widget resultsTab() {
  return ResultsScreen();
}

AppBar appBar() {
  return AppBar(
    title: Text(
      'Brain Analyzer',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    backgroundColor: const Color.fromARGB(255, 118, 141, 151),
    shadowColor: Colors.black54,
    elevation: 5,
    actionsPadding: EdgeInsets.only(right: 20),
    bottom: const TabBar(
      tabs: [
        Tab(
          icon: Icon(Icons.track_changes, color: Colors.white),
          text: 'Pipeline',
        ),
        Tab(
          icon: Icon(Icons.analytics, color: Colors.white),
          text: 'Analytics',
        ),
        Tab(
          icon: Icon(Icons.view_list, color: Colors.white),
          text: 'Results',
        ),
      ],
    ),
  );
}
