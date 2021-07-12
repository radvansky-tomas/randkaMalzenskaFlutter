import 'package:flutter/material.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class GridContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 20),
      child: FutureBuilder<List<Note>?>(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none) {
            print('project snapshot is null');
            return Container();
          }
          if (projectSnap.connectionState == ConnectionState.waiting) {
            print('project snapshot is loading');
            return Container();
          }
          if (projectSnap.data == null) {
            return Text('Brak notatek');
          }
          return ListView.builder(
            itemCount: projectSnap.data!.length,
            itemBuilder: (context, index) {
              Note note = projectSnap.data![index];
              return Column(
                children: <Widget>[Text(note.content!)],
              );
            },
          );
        },
        future: _read(),
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

  Future<List<Note>?> _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryNote();
  }
}
