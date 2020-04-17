/*
*
*   Database Structure
*     id, title, note, created_at, modified_at
*
* */

import 'package:notekeeper_flutter_solo/services/database/db_names.dart';

class Note{
  int id; // from database
  String title;
  String note;
  String createdAt;
  String modifiedAt;

  Note({
    this.title = '',
    this.note,
    this.createdAt,
    this.modifiedAt
});


  @override
  String toString() {
    super.toString();
    return "Title: $title, Note: $note";
  }

  Note.fromMap(Map<String, dynamic> map){
    this.id = map[DbNames.idCol];
    this.title = map[DbNames.titleTextCol];
    this.note = map[DbNames.noteTextCol];
    this.createdAt = map[DbNames.createdAtCol];
    this.modifiedAt = map[DbNames.modifiedAtCol];
  }

  toMap(){
    return Map<String, dynamic>.from({
//      DbNames.idCol: this.id,
      DbNames.titleTextCol: this.title,
      DbNames.noteTextCol: this.note,
      DbNames.createdAtCol: this.createdAt,
      DbNames.modifiedAtCol: this.modifiedAt
    });
  }
}