class DbNames{
  static String _dbName = "notekeeper.db";
  static String _tableName = "notes";
  static String _idCol = "id";
  static String _noteTextCol = "note_text";
  static String _titleTextCol = "note_title";
  static String _createdAtCol = "created_at";
  static String _modifiedAtCol = "modified_at";

  static String get dbName => _dbName;
  static String get tableName => _tableName;
  static String get idCol => _idCol;
  static String get noteTextCol => _noteTextCol;
  static String get titleTextCol => _titleTextCol;
  static String get createdAtCol => _createdAtCol;
  static String get modifiedAtCol => _modifiedAtCol;
}