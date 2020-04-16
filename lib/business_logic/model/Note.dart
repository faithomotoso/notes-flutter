/*
*
*   Database Structure
*     id, note, created_at, modified_at
*
* */

class Note{
  int id; // from database?
  String title;
  String note;
  String createdAt;
  String modifiedAt;

  Note({
    this.title,
    this.note,
    this.createdAt,
    this.modifiedAt
});

  Note.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.title = map['title'];
    this.note = map['note'];
    this.createdAt = map['created_at'];
    this.modifiedAt = map['modified_at'];
  }

  toMap(){
    return Map<String, dynamic>.from({
      "id": this.id,
      "title": this.title,
      "note": this.note,
      "created_at": this.createdAt,
      "modified_at": this.modifiedAt
    });
  }
}