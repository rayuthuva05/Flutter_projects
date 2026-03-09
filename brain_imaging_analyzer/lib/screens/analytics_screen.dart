import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      children: [
        DatasetModelInfo(),
        SizedBox(height: 20),
        GraphVisual(),
        SizedBox(height: 20),
        PerformanceMetrices(),
      ],
    );
  }
}

class DatasetModelInfo extends StatefulWidget {
  const DatasetModelInfo({super.key});

  @override
  State<DatasetModelInfo> createState() => _DatasetModelInfoState();
}

class _DatasetModelInfoState extends State<DatasetModelInfo> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_right,
                        size: 40,
                        color: Color.fromARGB(255, 37, 9, 113),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.remove_red_eye_sharp,
                          color: Color.fromARGB(255, 37, 9, 113),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Datasets Info',
                          style: TextStyle(
                            color: Color.fromARGB(255, 37, 9, 113),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: SizedBox(
                width: 400,
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I. Data Modality: dMRI/DTI',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'II. Dataset Name: ABIDE II',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'III. Total no of Subjects: 260',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'IV. Total no of ASD: 160',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'V. Total no HC: 90',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'VI. Age Range: 5-18 years old',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_right,
                        size: 40,
                        color: Color.fromARGB(255, 37, 9, 113),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.remove_red_eye_sharp,
                          color: Color.fromARGB(255, 37, 9, 113),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Model Info',
                          style: TextStyle(
                            color: Color.fromARGB(255, 37, 9, 113),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: SizedBox(
                width: 400,
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I. Model name: ASD_GNN_v2',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'II. Architecture type: GCN, GNN',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'III. Task Type: Binary Classification',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'IV. Input type: Connectivity Matrix/ Atlas AAL90',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'V. No of Nodes: 90',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'VI. No of Edges: Fully Connected',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ],
    );
  }
}

class GraphVisual extends StatefulWidget {
  const GraphVisual({super.key});

  @override
  State<GraphVisual> createState() => _GraphVisual();
}

class _GraphVisual extends State<GraphVisual> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: Color.fromARGB(255, 37, 9, 113),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.graphic_eq,
                      color: Color.fromARGB(255, 37, 9, 113),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Graph Visualizations',
                      style: TextStyle(
                        color: Color.fromARGB(255, 37, 9, 113),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(),
          secondChild: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(right: 10, left: 5, top: 20),
                  color: Colors.white10,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                      ),
                      backgroundColor: Colors.grey[100],
                      maxY: 20,
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [BarChartRodData(toY: 8, width: 20)],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [BarChartRodData(toY: 5, width: 20)],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [BarChartRodData(toY: 9, width: 20)],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [BarChartRodData(toY: 3, width: 20)],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class PerformanceMetrices extends StatefulWidget {
  const PerformanceMetrices({super.key});

  @override
  State<PerformanceMetrices> createState() => _PerformanceMetricesState();
}

class _PerformanceMetricesState extends State<PerformanceMetrices> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: Color.fromARGB(255, 37, 9, 113),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.medical_information,
                      color: Color.fromARGB(255, 37, 9, 113),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Model Performance Metrices',
                      style: TextStyle(
                        color: Color.fromARGB(255, 37, 9, 113),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(),
          secondChild: Metrices(),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class Metrices extends StatefulWidget {
  const Metrices({super.key});

  @override
  State<Metrices> createState() => _MetricesState();
}

class _MetricesState extends State<Metrices> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 40,
      mainAxisSpacing: 40,
      crossAxisCount: 4,
      padding: EdgeInsets.all(20),
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          shadowColor: Colors.black54,
          elevation: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Accuracy',style: TextStyle(fontSize: 24)),
                Text('94.65%',style: TextStyle(fontSize: 18,color: Colors.grey[600]),)
              ],
          )),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          shadowColor: Colors.black54,
          elevation: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Precision',style: TextStyle(fontSize: 24)),
                Text('94.65%',style: TextStyle(fontSize: 18,color: Colors.grey[600]),)
              ],
          )),
        ),Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          shadowColor: Colors.black54,
          elevation: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Recall',style: TextStyle(fontSize: 24)),
                Text('94.65%',style: TextStyle(fontSize: 18,color: Colors.grey[600]),)
              ],
          )),
        ),Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          shadowColor: Colors.black54,
          elevation: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('F1 Score',style: TextStyle(fontSize: 24)),
                Text('94.65%',style: TextStyle(fontSize: 18,color: Colors.grey[600]),)
              ],
          )),
        ),
      ],
    );
  }
}
