import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initiateDatabase();

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "tarbiyat.db");
    return await openDatabase(path, version: 1, onCreate: _Oncreate);
  }

  _Oncreate(Database db, int version) {
    db.execute('''
      CREATE TABLE routine (id INTEGER PRIMARY KEY, cdate TEXT, title TEXT, buttons TEXT, status INTEGER);
      ''');
    db.execute('''
      CREATE TABLE answers (id INTEGER PRIMARY KEY, adatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,its INTEGER, rid INTEGER ,buttons TEXT , status INTEGER);
      ''');
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Fajr Namaz','امامة,اداء,قضاء,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Siwaak','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Gusul/Nazafat','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Waledain Salaam','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Tilawat al Quran','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Zohr Asr Namaz','امامة,اداء,قضاء,No',1)");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Homework','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Maghrib Isha Namaz','امامة,اداء,قضاء,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Wazifatul Layl','Yes,No',1);");
    db.rawInsert(
        "INSERT into routine(cdate,title,buttons,status) values('53','Siwaak','Yes,No',1);");
  }

  // int i =
  // insert({'cdate': '2021-12-08', 'title': '', 'buttons': '', 'status': 1});

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(String table, String where, String param,
      Map<String, dynamic> row) async {
    Database db = await instance.database;
    // int id = row['id'];
    return await db.update(table, row, where: where, whereArgs: [param]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryRaw(String query, List params) async {
    Database db = await instance.database;
    return await db.rawQuery(query, params);
  }

  Future<int> updateRaw(String query, List params) async {
    Database db = await instance.database;
    return await db.rawUpdate(query, params);
  }
}
