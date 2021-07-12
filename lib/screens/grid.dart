import 'package:flutter/material.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class GridContent extends StatefulWidget {
  @override
  _GridContentState createState() => _GridContentState();
}

class _GridContentState extends State<GridContent> {
  Future<List<Note>?>? _notes;
  int lenght = 0;

  @override
  void initState() {
    super.initState();
    _notes = _read();
  }

  @override
  Widget build(BuildContext context) {
    Note note1 = new Note();
    note1.content = 'zawartosc';
    note1.title = 'nowy tytul';

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 20),
      child: FutureBuilder<List<Note>?>(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none) {
            print('project snapshot is null');
            return Container();
          }
          if (projectSnap.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
            // return Container();
          }
          if (projectSnap.data == null) {
            return Text('Brak notatek');
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _insert(note1),
            ),
            body: ListView.builder(
              itemCount: projectSnap.data!.length,
              itemBuilder: (context, index) {
                Note note = projectSnap.data![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                    child: Column(
                      children: <Widget>[Text(note.content!)],
                    ),
                  ),
                );
              },
            ),
          );
        },
        future: _notes,
      ),
    );
  }

  _save() async {
    Note note = Note();
    note.title = 'tytul';
    note.content = 'moj ulubiony kurs to dzien 4 odcinek 6';
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(note);
    print('inserted row: $id');
  }

  Future<int> _insert(Note note) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    setState(() {
      _notes = _read();
    });
    return await helper.insert(note);
  }

  Future<List<Note>?> _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryNote();
  }
}
