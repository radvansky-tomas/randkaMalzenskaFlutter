import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/note_view.dart';
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
            return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NoteView(NoteMode.Adding, refresh, null);
                      },
                    ),
                  );
                },
              ),
              body: Container(
                alignment: Alignment.center,
                child: Text(
                  'Brak notatek, kliknij plusik aby dodać swoją pierwsza notatkę',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NoteView(NoteMode.Adding, refresh, null);
                    },
                  ),
                );
              },
            ),
            body: ListView.builder(
              itemCount: projectSnap.data!.length,
              itemBuilder: (context, index) {
                Note note = projectSnap.data![index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NoteView(NoteMode.Edditing, refresh, note);
                        },
                      ),
                    )
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            note.title!,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            note.content!,
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
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

  refresh() {
    setState(() {
      _notes = _read();
    });
  }

  Future<List<Note>?> _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.queryNote();
  }
}
