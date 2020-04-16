import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class AllNotesModel extends ChangeNotifier{
  final Database _databaseService = serviceLocator<Database>();

  List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  void loadNotes() async {
    _allNotes = await _databaseService.getAllNotes();
    notifyListeners();
  }


}