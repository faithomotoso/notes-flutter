import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSim implements DatabaseAbs {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  @override
  Future<List<Note>> getAllNotes() async {
    // fetch new notes from database
    // TODO: clear list then fetch
    if (_notes.isEmpty) {
      _notes.addAll(
          List.generate(7, (n) => Note(note: "Note $n", createdAt: "Today")));
      _notes.add(Note(
          title: "Long Sample new note",
          note:
              "This should be a long note to show the difference in size I guess, size should be dynamic and stuff"));
      _notes.addAll(List.generate(
          3, (n) => Note(note: "New note", title: "Random Strings $n")));
    }
    return _notes;
  }

  @override
  Future<int> createNote({Note newNote}) {
//    _notes.add(newNote);
    newNote.createdAt = DateTime.now().toString();
    _notes.insert(0, newNote);
    return null;
  }

  @override
  Future<int> deleteNote({Note note}) {
//    _notes.removeAt(note.id);
    _notes.removeWhere((n) => n == note);
    return null;
  }

  @override
  Future<int> saveNote(
      {@required Note note, String titleText, String noteText}) {
    // for database use note.id
    int i = _notes.indexWhere((n) => n == note);
    note.title = titleText;
    note.note = noteText;
    note.modifiedAt = DateTime.now().toString();
    _notes[i] = note;
    return null;
  }

  @override
  Future<void> onCreateDb(Database db, int version) {
    // TODO: implement onCreateDatabase
  }

  @override
  Future<Database> openDb() {
    // TODO: implement openDatabase
    return null;
  }

  @override
  Future init() {
    // TODO: implement init
    return null;
  }
}
