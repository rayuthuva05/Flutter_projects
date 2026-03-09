import 'package:brain_imaging_analyzer/screens/analytics_screen.dart';
import 'package:brain_imaging_analyzer/screens/results_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: appBar(),
        floatingActionButton: fAB(context),
        body: TabBarView(
          children: [
            Tab(child: guideTab()),
            Tab(child: workflowTab()),
            Tab(child: analyticalTab()),
            Tab(child: resultsTab()),
          ],
        ),
      ),
    );
  }
}

Widget guideTab() {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.book_rounded, color: Color.fromARGB(255, 37, 9, 113)),
            SizedBox(width: 10),
            Text(
              'Guides',
              style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 37, 9, 113),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Divider(height: 20, thickness: 3),
        Text(
          "The Guides section provides a structured overview of the neuroimaging processing pipeline and explainable AI integration used in this application. It outlines each essential step, beginning from raw imaging formats (.hdr/.img) and progressing through preprocessing procedures such as conversion to NIfTI format, skull stripping, image registration, and diffusion tensor modeling. This section is designed to support students and researchers by explaining the purpose, input requirements, and expected outputs of each stage in a clear and systematic manner. In addition, it introduces the role of Explainable AI in interpreting diffusion metrics, helping users understand how model predictions are generated and which features contribute most to the final outcome. The goal of this section is not to replace desktop processing tools, but to serve as an educational and reference companion for accurate and transparent neuroimaging analysis.\n \n The Guides section provides a structured overview of the neuroimaging processing pipeline and explainable AI integration used in this application. It outlines each essential step, beginning from raw imaging formats (.hdr/.img) and progressing through preprocessing procedures such as conversion to NIfTI format, skull stripping, image registration, and diffusion tensor modeling. This section is designed to support students and researchers by explaining the purpose, input requirements, and expected outputs of each stage in a clear and systematic manner. In addition, it introduces the role of Explainable AI in interpreting diffusion metrics, helping users understand how model predictions are generated and which features contribute most to the final outcome. The goal of this section is not to replace desktop processing tools, but to serve as an educational and reference companion for accurate and transparent neuroimaging analysis.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}

Widget workflowTab() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.track_changes, color: Color.fromARGB(255, 37, 9, 113)),
            SizedBox(width: 10),
            Text(
              'Work flow',
              style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 37, 9, 113),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Divider(),
        Text(
          "The Workflow section presents a step-by-step overview of the neuroimaging processing pipeline used in this study. It guides users from the initial raw image format (.hdr/.img) through structured preprocessing stages, including format conversion to NIfTI, skull stripping, spatial registration, and diffusion tensor model fitting. Each step is organized sequentially to reflect standard laboratory practice, ensuring clarity and reproducibility. After preprocessing, the extracted diffusion metrics such as FA, MD, AD, and RD are prepared for analysis within the Explainable AI module. This structured workflow helps users monitor progress, understand data dependencies between stages, and maintain consistency throughout the analysis process. The objective is to reinforce proper methodological order while supporting transparent and systematic neuroimaging research.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Image(image: AssetImage('assets/images/Picture1.png')),
      ],
    ),
  );
}

Widget analyticalTab() {
  return AnalyticsScreen();
}

Widget resultsTab() {
  return ResultsScreen(
    subjectId: 'N/A',
    prediction: "No run yet",
    confident: "0",
  );
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
          icon: Icon(Icons.book, color: Colors.white),
          text: "Guides",
        ),
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

FloatingActionButton fAB(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () {
      Navigator.pushNamed(context, 'run-newData');
    },
    icon: Icon(Icons.electric_bolt, color: Colors.amber),
    label: Text('Run with XAI', style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.blue,
  );
}
