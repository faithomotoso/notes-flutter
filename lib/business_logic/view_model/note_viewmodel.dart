import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/business_logic/view_model/all_notes_viewmodel.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class NoteViewModel extends ChangeNotifier{
  NoteViewModel({@required Note note});

  final Database _databaseService = serviceLocator<Database>();
  final AllNotesModel allNotesModel = AllNotesModel();

  Future<void> createNewNote({@required Note newNote}){
    _databaseService.createNote(newNote: newNote);
    allNotesModel.loadNotes();
  }
}