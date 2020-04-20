import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/database/database_service.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class AllNotesModel extends ChangeNotifier{
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();

  List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  List<Note> _selectedNotes = [];
  List<Note> get selectedNotes => _selectedNotes;

//  bool longPressActivated = false;
  ValueNotifier mode = ValueNotifier<bool>(false); // use for enabling or disabling selection mode

  void loadNotes() async {
    _allNotes.clear();
    await _databaseService.init();
    _allNotes = await _databaseService.getAllNotes();
    notifyListeners();
  }

  void addToSelectedNotes({@required Note note}){
    _selectedNotes.add(note);
    notifyListeners();
  }

  void removeFromSelectedNotes({@required Note note}){
    _selectedNotes.remove(note);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
//    print(_allNotes);
//    print("Length: ${_allNotes.length}");
  }

  Future deleteSelectedNotes() async {
    _selectedNotes.forEach((note) async {
//      _allNotes.removeWhere((n) => n.id == note.id);
      print("Deleting: ${_allNotes.remove(note)}");
//      await _databaseService.deleteNote(note: note);
    });
    mode.value = false;
    _selectedNotes.clear();
    notifyListeners();
//    loadNotes();
  }

  void delete(){
    _allNotes.removeAt(0);
    notifyListeners();
  }

}