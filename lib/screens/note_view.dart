import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

enum NoteMode { Edditing, Adding }

class NoteView extends StatefulWidget {
  final NoteMode noteMode;
  final Function() notifyParent;
  final Note? note;

  NoteView(this.noteMode, this.notifyParent, this.note);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Edditing) {
      _titleController.text = widget.note!.title!;
      _textController.text = widget.note!.content!;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteMode == NoteMode.Adding
            ? 'Dodaj notatke'
            : 'Edytuj notatke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Tytuł notatki'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Treść notatki'),
            ),
            Container(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NoteButton('Zapisz', Colors.blue, () {
                  if (widget.noteMode == NoteMode.Adding) {
                    final title = _titleController.text;
                    final text = _textController.text;
                    _insert(title, text);
                    widget.notifyParent();
                    Navigator.pop(context);
                  } else if (widget.noteMode == NoteMode.Edditing) {
                    _update(_titleController.text, _textController.text,
                        widget.note!.id!);
                    widget.notifyParent();
                    Navigator.pop(context);
                  }
                }),
                _NoteButton('Cofnij', Colors.grey[600]!, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Edditing
                    ? _NoteButton('Usuń', Colors.red[300]!, () {
                        _delete(widget.note!.id!);
                        widget.notifyParent();
                        Navigator.pop(context);
                      })
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}

_delete(int id) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.deleteNote(id);
}

_update(String title, String text, int id) async {
  Note note = new Note();
  note.title = title;
  note.content = text;
  note.id = id;
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.updateNote(note.toMap());
}

Future<int> _insert(String title, String text) async {
  Note note = new Note();
  note.title = title;
  note.content = text;
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.insert(note);
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final VoidCallback _onPressed;
  _NoteButton(this._text, this._color, this._onPressed);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: _onPressed,
        child: Text(
          _text,
          style: TextStyle(color: Colors.white),
        ),
        color: _color);
  }
}
