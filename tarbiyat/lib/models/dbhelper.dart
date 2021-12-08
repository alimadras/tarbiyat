import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _dbName = 'tarbiyat.db';
  static final _dbVersion = 1;

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    await openDatabase(path, version: _dbVersion, onCreate: _Oncreate);
  }

  _Oncreate(Database db, int version) {
    db.execute('''
      CREATE TABLE routine (id INTEGER PRIMARY KEY, cdate TEXT, title TEXT, buttons TEXT, status INTEGER);
      INSERT into routine(cdate,title,buttons,status) values('2021-12-08','Fajr Namaz','امامة,اداء,قضاء,No',1);
      ''');
  }

  // int i =
  // insert({'cdate': '2021-12-08', 'title': '', 'buttons': '', 'status': 1});

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('routine', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query('routine');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('routine', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('routine', where: 'id = ?', whereArgs: [id]);
  }
}
