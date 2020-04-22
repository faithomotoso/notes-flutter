import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/database/database_service.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class NoteViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();
  final AllNotesModel _allNotesModel = serviceLocator<AllNotesModel>();

  void createNewNote({@required String title, @required String note}) async {
    // if title is empty store as null
    Note newNote = Note(title: title, note: note, createdAt: DateTime.now().toString());
    try {
      int result = await _databaseService.createNote(newNote: newNote);
    } on Exception catch (e) {
      debugPrint("Error creating note: ${e.toString()}");
    }
    _allNotesModel.loadNotes();
  }


  void saveNote(
      {@required Note note, String titleText, String noteText, @required bool isPinned}) async {
    try {
      await _databaseService.saveNote(
          note: note, titleText: titleText, noteText: noteText, isPinned: isPinned);
    } on Exception catch (e) {
      debugPrint("Error saving note: ${e.toString()}");
    }
    _allNotesModel.loadNotes();
  }

  void deleteNote({@required Note note}) async {
    try {
      await _databaseService.deleteNote(note: note);
    } on Exception catch (e) {
      debugPrint("Error deleting note: ${e.toString()}");
    }
    _allNotesModel.loadNotes();
  }
}
