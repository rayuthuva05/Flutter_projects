import 'package:brain_imaging_analyzer/screens/home_screen.dart';
import 'package:brain_imaging_analyzer/screens/run_new_data.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

<<<<<<< HEAD
Future<void> main() async {
=======
void main() async {
>>>>>>> 4fe9b627cc471e3e9c120fdf4cd682c39974949e
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),
    center: true,
    title: "Brain Imaging Analyzer App - ASD",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const BrainImagingApp());
}

class BrainImagingApp extends StatelessWidget {
  const BrainImagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'Brain Analyzer',
      routes: {'/': (context) => HomeScreen(), 'run-newData': (context)=> RunNewData()},
    );
  }
}
