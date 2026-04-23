import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/services/note_service.dart';
import 'package:rest_api/views/note_list.dart';
import 'package:rest_api/views/note_modify.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(const APIApp());
}

class APIApp extends StatelessWidget {
  const APIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rest API',
      theme: ThemeData(primarySwatch: Colors.red),
      home: NoteList(),
      routes: {'create-modify': (context) => NoteModify()},
    );
  }
}
