import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class AllNotesModel extends ChangeNotifier{
  final DatabaseAbs _databaseService = serviceLocator<DatabaseAbs>();

  List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  String instance;


  void loadNotes() async {
    _allNotes.clear();
    await _databaseService.init();
    _allNotes = await _databaseService.getAllNotes();
    notifyListeners();
  }

}