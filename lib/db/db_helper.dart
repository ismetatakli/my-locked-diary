import 'dart:async';
import 'dart:io';
import 'package:mylockeddiary/models/author.dart';
import 'package:mylockeddiary/models/diary.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper{

  static DbHelper _dbHelper;
  static Database _database;
  
  
  // DIARY TABLE COLUMN NAMES//
  String _diaryTable = "diary";
  String _diaryId = "diaryId";
  String _diaryTitle = "diaryTitle";
  String _diaryContent = "diaryContent";
  String _diaryAuthorId = "diaryAuthorId";
  String _diaryDate = "diaryDate";

  //AUTHOR TABLE COLUMN NAMES//

  String _authorTable = "author";
  String _authorId = "authorId";
  String _authorName = "authorName";
  String _authorPassword = "authorPassword";

  DbHelper._internal();

  factory DbHelper(){

    if(_dbHelper == null){
      _dbHelper = DbHelper._internal();
      return _dbHelper;
    }
    else{
      return _dbHelper;
    }
     
  }

  Future<Database> _getDatabase() async {
    if(_database == null){
      _database = await _initializeDatabase();
      return _database;
    }
    else{
      return _database;
    }

  }

  _initializeDatabase() async{
    Directory klasor = await getApplicationDocumentsDirectory();
    String path = join(klasor.path,"diaryOriginal1.db");
    print("Oluşan veritabanı tam yolu: $path");

    var diaryDB = await openDatabase(path,version: 1,onCreate: _createDB);
    
    return diaryDB;
    
    }
    
      
    
    
    
    
    
    
    
    
  Future _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE $_diaryTable ($_diaryId INTEGER PRIMARY KEY AUTOINCREMENT, $_diaryTitle TEXT, $_diaryContent TEXT, $_diaryAuthorId INTEGER, $_diaryDate TEXT)");
    await db.execute("CREATE TABLE $_authorTable ($_authorId INTEGER PRIMARY KEY AUTOINCREMENT, $_authorName TEXT, $_authorPassword TEXT)");
  }

  Future<int> updateAuthorPassword(int userId,String newPassword) async{
    var db = await _getDatabase();
    var result = db.rawUpdate('UPDATE $_authorTable SET $_authorPassword = "$newPassword" WHERE $_authorId == $userId');
    return result;
  }

  Future<int> newDiary(Diary diary) async{
    var db = await _getDatabase();
    var result = db.insert(_diaryTable, diary.toMap()); 
    return result;
  }

  Future<int> newAuthor(Author author) async{
    var db = await _getDatabase();
    var result = db.insert(_authorTable, author.toMap()); 
    return result;
  }

  Future<List<Map<String, dynamic>>> allAuthors() async{
    var db = await _getDatabase();
    var result = db.query(_authorTable);
    return result;
  }

  

  // Future<List<Map<String, dynamic>>> isThereAuthor(String authorName) async{
  //   var db = await _getDatabase();
  //   var result = db.query(_authorTable,where: "$_authorName == '$authorName'");
  //   return result;
  // }

  Future<List<Map<String, dynamic>>> groupedDiariesWithDate(int authorId) async{
    var db = await _getDatabase();
    var result = db.rawQuery("SELECT $_diaryDate FROM $_diaryTable WHERE $_diaryAuthorId == $authorId GROUP BY $_diaryDate ORDER BY $_diaryDate DESC" );
    return result;
  }

    
  Future<List<Map<String, dynamic>>> allDiariesWithAuthorId(int authorId) async{
    var db = await _getDatabase();
    var result = db.query(_diaryTable,where: "$_diaryAuthorId == $authorId", orderBy: '$_diaryId DESC');
    return result;
  }

  Future<int> deleteAuthor(int authorId) async{
    var db = await _getDatabase();
    var result = db.delete(_authorTable,where: "$_authorId == $authorId");
    return result;
  }

  Future<int> deleteDiariesWithAuthorId(int authorId) async{
    var db = await _getDatabase();
    var result = db.delete(_diaryTable,where: "$_diaryAuthorId == $authorId");

    return result;
  }


}