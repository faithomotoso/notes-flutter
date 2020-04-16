import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';

class DatabaseSim implements Database {
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
  Future<void> createNote({Note newNote}) {
    _notes.add(newNote);
    return null;
  }

  @override
  Future<void> deleteNote({Note note}) {
    _notes.removeAt(note.id);
    return null;
  }

  @override
  Future<void> saveNote({Note note}) {
    _notes[note.id] = note;
    return null;
  }
}
