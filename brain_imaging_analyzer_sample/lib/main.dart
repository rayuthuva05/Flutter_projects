import 'package:brain_imaging_analyzer/models/prediction_model.dart';
import 'package:brain_imaging_analyzer/screens/run_new_data.dart';
import 'package:brain_imaging_analyzer/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),
    center: true,
    title: "BImage App",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(PredictionModelAdapter());
  await Hive.openBox<PredictionModel>("predictions");

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
      routes: {
        '/': (context) => SplashScreen(),
        'run-newData': (context) => RunNewData(),
      },
    );
  }
}
