import 'dart:convert';

import 'package:rest_api/models/api_response.dart';
import 'package:rest_api/models/note_listing.dart';
import 'package:http/http.dart' as http;

class NoteService {
  // List<NoteListing> getNotesList() {
  //   return [
  //     NoteListing("1", "Meeting Notes", DateTime.now(), DateTime.now()),
  //     NoteListing("2", "Grocery List", DateTime.now(), DateTime.now()),
  //     NoteListing("3", "Project Ideas", DateTime.now(), DateTime.now()),
  //     NoteListing("4", "Workout Plan", DateTime.now(), DateTime.now()),
  //     NoteListing("5", "Study Schedule", DateTime.now(), DateTime.now()),
  //     NoteListing("6", "Travel Checklist", DateTime.now(), DateTime.now()),
  //     NoteListing("7", "App Ideas", DateTime.now(), DateTime.now()),
  //     NoteListing("8", "Daily Journal", DateTime.now(), DateTime.now()),
  //     NoteListing("9", "Client Feedback", DateTime.now(), DateTime.now()),
  //     NoteListing("10", "Bug Fix Notes", DateTime.now(), DateTime.now()),
  //   ];
  // }

  static const api = 'https://69e8a05755d62f347979912f.mockapi.io/api/p1';

  Future<ApiResponse<List<NoteListing>>> getNotesList() {
    return http
        .get(Uri.parse(api + '/notes'), headers: {'Content-Type': 'application/json'})
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = jsonDecode(data.body);
            final notes = <NoteListing>[];
            for (var item in jsonData) {
              final note = NoteListing(
                item['noteID'],
                item['noteTitle'],
                DateTime.parse(item['createDateTime']),
                DateTime.parse(item['lastEditDate']),
              );
              notes.add(note);
            }
            return ApiResponse<List<NoteListing>>(data: notes);
          }
          return ApiResponse<List<NoteListing>>(
            error: true,
            errormessage: 'An error occured.',
          );
        })
        .catchError(
          (_) => ApiResponse<List<NoteListing>>(
            error: true,
            errormessage: 'An error occured.',
          ),
        );
  }
}
