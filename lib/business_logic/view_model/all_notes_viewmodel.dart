import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/database/database_service.dart';
import 'package:notekeeper_flutter_solo/services/service_locator.dart';

class AllNotesModel extends ChangeNotifier{
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();

  List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  List<Note> _pinnedNotes = [];
  List<Note> get pinnedNotes => _pinnedNotes;

  List<Note> _selectedNotes = [];
  List<Note> get selectedNotes => _selectedNotes;

//  bool longPressActivated = false;
  ValueNotifier mode = ValueNotifier<bool>(false); // use for enabling or disabling selection mode

  void loadNotes() async {
    _allNotes.clear();
    await _databaseService.init();
    _allNotes = await _databaseService.getAllNotes();

    // add pinned notes
//    _pinnedNotes.addAll(_allNotes.where((note) => note.isPinned));
    _pinnedNotes = _allNotes.where((note) => note.isPinned).toList();
    print("Pinned notes: $_pinnedNotes");
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
    mode.value = false;
    _selectedNotes.forEach((note) async {
      try {
        _allNotes.removeWhere((n) => n.id == note.id);

        // if note is pinned, delete from pinned notes
        if (note.isPinned){
          _pinnedNotes.removeWhere((n) => n.id == note.id);
        }

        await _databaseService.deleteNote(note: note);
      } on Exception catch (e) {
        debugPrint("Error deleting note: $note -> ${e.toString()}");
      }
    });
    _selectedNotes.clear();
    notifyListeners();
  }

}