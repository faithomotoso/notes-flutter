import 'dart:ffi';

import 'package:notekeeper_flutter_solo/business_logic/model/Note.dart';
import 'package:notekeeper_flutter_solo/services/database/database.dart';
import 'package:notekeeper_flutter_solo/services/database/db_names.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService implements DatabaseAbs {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Database _db;

  init() async {
    if (_db == null) {
      _db = await openDb();
    }
  }

  @override
  Future<Database> openDb() async {
    String systemDbPath = await getDatabasesPath();
    String dbPath = join(systemDbPath, DbNames.dbName);
    return await openDatabase(dbPath, version: 1, onCreate: onCreateDb);
  }

  @override
  Future<void> onCreateDb(Database db, int version) async {
    return await db.execute("""
    CREATE TABLE ${DbNames.tableName}(
    ${DbNames.idCol} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${DbNames.titleTextCol} TEXT,
    ${DbNames.noteTextCol} TEXT,
    ${DbNames.createdAtCol} TEXT,
    ${DbNames.modifiedAtCol} TEXT,
    ${DbNames.isPinned} INTEGER NOT NULL DEFAULT 0
    )
    """);
  }

  @override
  Future<int> createNote({Note newNote}) async {
    int result = await _db.insert(DbNames.tableName, newNote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);

    return result;
  }

  @override
  Future<int> deleteNote({Note note}) async {
    int result = await _db
        .delete(DbNames.tableName, where: "id = ?", whereArgs: [note.id]);
    return result;
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> list =
        await _db.query(DbNames.tableName, orderBy: "${DbNames.idCol} DESC");

    list.forEach((map) => _notes.add(Note.fromMap(map)));
    return _notes;
  }

  @override
  Future<int> saveNote(
      {Note note, String titleText, String noteText, bool isPinned}) async {
    note.title = titleText;
    note.note = noteText;
    note.isPinned = isPinned;
    note.modifiedAt = DateTime.now().toString();

    int result = await _db.update(DbNames.tableName, note.toMap(),
        where: "id = ?", whereArgs: [note.id]);

    return result;
  }

  Future updateNotePinStatus({Note note}) async {
    await _db.update(DbNames.tableName, note.toMap(),
        where: "id = ?", whereArgs: [note.id]);
  }
}
