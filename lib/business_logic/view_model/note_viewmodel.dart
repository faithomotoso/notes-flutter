import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class NoteViewModel extends ChangeNotifier {
  final DatabaseAbs _databaseService = serviceLocator<DatabaseAbs>();
  final AllNotesModel _allNotesModel = serviceLocator<AllNotesModel>();

  void createNewNote({@required String title, @required String note}) async {
    // if title is empty store as null
    Note newNote = Note(title: title, note: note);
    int result = await _databaseService.createNote(newNote: newNote);
    _allNotesModel.loadNotes();
    print("Creating note result: $result");
  }

  void saveNote(
      {@required Note note, String titleText, String noteText}) async {
    // index for database sim
    await _databaseService.saveNote(
        note: note, titleText: titleText, noteText: noteText);
    _allNotesModel.loadNotes();
  }

  void deleteNote({@required Note note}) async {
    await _databaseService.deleteNote(note: note);
    _allNotesModel.loadNotes();
  }
}
