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

  ValueNotifier mode = ValueNotifier<bool>(false); // use for enabling or disabling selection mode

  bool evalPinnedIcon(){
    // this method should be called when a note is selected
    // result would determine the pin icon to display in home.dart and action
    // to carry out when tapped
    bool def = true;

    _selectedNotes.forEach((n) => def &= n.isPinned);
    return def;
  }

  void pinUnpinSelectedNotes(){
    bool action = evalPinnedIcon(); // if false => pin unpinned notes, if true => unpin pinned notes
    if (!action){
      _selectedNotes.forEach((n){
        if (!n.isPinned){
          // pinning unpinned notes
          n.isPinned = true;
          _databaseService.updateNotePinStatus(note: n);
          _pinnedNotes.add(n);
        }
      });
    } else {
      // unpin notes
      _selectedNotes.forEach((n){
        n.isPinned = false;
        _databaseService.updateNotePinStatus(note: n);
        _pinnedNotes.removeWhere((note) => note.id == n.id);
      });
    }
    mode.value = false;
    _selectedNotes.clear();
    _pinnedNotes.sort((a, b) => b.id.compareTo(a.id));
    notifyListeners();
  }

  void loadNotes() async {
    _allNotes.clear();
    await _databaseService.init();
    _allNotes = await _databaseService.getAllNotes();

    // add pinned notes
    _pinnedNotes = _allNotes.where((note) => note.isPinned).toList();
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