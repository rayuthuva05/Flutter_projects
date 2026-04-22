import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.subjectId,
    required this.prediction,
    required this.confident,
  });

  final String subjectId;
  final String prediction;
  final String confident;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardThemeData(color: Colors.blue.shade50),
      ),
      home: ResultsPage(),
    );
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
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
                      EdgeInsets.symmetric(horizontal: 8)
                    ),
                    leading: const Icon(Icons.search),
                    hintText: 'Search by SubjectId',
                    hintStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12,color: Colors.grey)),
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14,color: const Color.fromARGB(255, 37, 9, 113),fontWeight: FontWeight.w500)),
                    elevation: WidgetStatePropertyAll(5.0),
                    overlayColor: WidgetStatePropertyAll(const Color.fromARGB(255, 248, 243, 226)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton.icon(
                    onPressed: () {},
                    label: Text('Sort', style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.sort_sharp, color: Colors.white),
                ),
              ],
            )
          ],
          actionsPadding: EdgeInsetsGeometry.symmetric(vertical: 10),
        ),
        SliverGrid.count(
          crossAxisCount: 4,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(60, (index) {
            int count = 4;
            int row = index ~/ count;
            int col = index % count;

            Color color = (row + col) % 2 == 0
                ? Colors.green.shade300
                : Colors.blueGrey.shade100;

            return ItemWidget(text: 'data$index',color: color);
          }),
        ),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, required this.text,required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black54,
      elevation: 6,
      color: color,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Center(child: Text(text)),
    );
  }
}
