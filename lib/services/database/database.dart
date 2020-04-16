
import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';

abstract class Database{
  Future<List<Note>> getAllNotes();

  Future<void> createNote({@required Note newNote});

  Future<void> saveNote({@required Note note});

  Future<void> deleteNote({@required Note note});

}