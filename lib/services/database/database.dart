
import 'package:flutter/cupertino.dart';
import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseAbs{
  Future<Database> openDb();

  Future<void> onCreateDb(Database db, int version);

  Future<dynamic> init();

  Future<List<Note>> getAllNotes();

  Future<int> createNote({@required Note newNote});

  Future<int> saveNote({@required Note note, String titleText, String noteText});

  Future<int> deleteNote({@required Note note});

}