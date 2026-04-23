import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/api_response.dart';
import 'package:rest_api/models/note_listing.dart';
import 'package:rest_api/services/note_service.dart';
import 'package:rest_api/views/note_delete.dart';

class NoteList extends StatefulWidget {
  NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.instance<NoteService>();

  String formatDateTime(DateTime datetime) {
    return '${datetime.day}/${datetime.month}/${datetime.year}';
  }

  ApiResponse<List<NoteListing>>? _apiResponse;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  _fetchNotes() async {
    setState(() {
      _isloading = true;
    });

    _apiResponse = await service.getNotesList();
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'create-modify');
        },
        child: Icon(Icons.add_card),
      ),
      body: Builder(
        builder: (_) {
          if (_isloading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse == null) {
            return Center(child: Text("No data"));
          }

          if (_apiResponse!.error) {
            return Center(child: Text(_apiResponse!.errormessage ?? "Error"));
          }

          return ListView.separated(
            itemCount: _apiResponse!.data!.length,
            separatorBuilder: (_, _) => Divider(height: 1, color: Colors.green),
            itemBuilder: (_, index) {
              final note = _apiResponse!.data![index];

              return Dismissible(
                key: Key(note.noteID),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => NoteDelete(),
                  );
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    note.noteTitle,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                    "Last edited on ${formatDateTime(note.lastEditDate)}",
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'create-modify',
                      arguments: note.noteID,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
