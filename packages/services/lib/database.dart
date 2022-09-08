

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:services/data_models/db_os.dart';
import 'package:services/data_models/db_tmz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'data_models/db_warehouse.dart';

class DBProvider {
  static final DBProvider db = DBProvider();
  Database? _database;

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, 
    version: 1, 
    onOpen: (db){},
     onCreate: (Database db, int version ) async{
      await db.execute("CREATE TABLE OS_List ("
     "id TEXT PRIMARY KEY,"
      "code TEXT ,"
      " title TEXT,"
      " description TEXT,"
      " Warehouse_code TEXT"
      ")");

       await db.execute("CREATE TABLE Warehouse_List ("
      "code TEXT PRIMARY KEY,"
      " title TEXT"
      ")");

       await db.execute("CREATE TABLE TMZ_List ("
     "id TEXT PRIMARY KEY,"
      "code TEXT ,"
      " title TEXT,"
      " quantity INTEGER,"
       " barcode TEXT,"
      " Warehouse_code TEXT"
      ")");
      
    });
  }

  //OS
addOs(db_Os os) async{
  final db = await database;
  var ID = os.id;
  var raw;
  var res = await db.rawQuery("SELECT id, code, title, Warehouse_code FROM OS_List WHERE id = '$ID'"";");
  if(res.isEmpty == false){
    var raw = await db.rawUpdate('''
    UPDATE OS_List 
    SET code = ?, title = ?, Warehouse_code = ?
    WHERE id = ?
    ''', 
    [os.code, os.title, os.Warehouse_code, os.id]);
 //var raw = await db.update("OS_List", os.toMap(), where: 'id = ?', whereArgs: [os.id]);

  }else{
    var raw = await db.rawInsert(
  " INSERT INTO OS_List(id, code, title, Warehouse_code )"
  " VALUES (?,?,?,?)",
  [os.id, os.code, os.title, os.Warehouse_code], );}
  return raw;
}

Future<List<db_Os>> getAllOS(param) async{
  final db = await database;
  var res = await db.rawQuery("SELECT id, code, title, Warehouse_code FROM OS_List WHERE Warehouse_code = '$param'"";");
  var check = await db.query("OS_List");
  List<db_Os> list = res.isNotEmpty ? res.map((e) => db_Os.fromMap(e)).toList() : [];
  return list;
} 
 
   //TMZ
addTMZ(db_TMZ tmz) async{
  final db = await database;
  var ID = tmz.id;
  var raw;
  var check = await db.query("TMZ_List");
  var res = await db.rawQuery("SELECT id, code, title, quantity, barcode, Warehouse_code FROM TMZ_List WHERE id = '$ID'"";");
  if(res.isEmpty == false){
    var rawUPT = await db.rawUpdate('''
    UPDATE TMZ_List 
    SET code = ?, title = ?, quantity = ?, barcode = ?, Warehouse_code = ?
    WHERE id = ?
    ''', 
    [tmz.code, tmz.title, tmz.quantity, tmz.barcode, tmz.Warehouse_code, tmz.id]);
  var raw = await db.rawQuery("SELECT id, code, title, quantity, barcode,  Warehouse_code FROM TMZ_List WHERE id = '$ID'"";");

  }else{
    var raw = await db.rawInsert(
  " INSERT INTO TMZ_List(id, code, title, quantity, barcode, Warehouse_code )"
  " VALUES (?,?,?,?,?,?)",
  [tmz.id, tmz.code, tmz.title, tmz.quantity, tmz.barcode, tmz.Warehouse_code], );}
  return raw;
}

Future<List<db_TMZ>> getAllTMZ(param) async{
  final db = await database;
  var res = await db.rawQuery("SELECT id, code, title, quantity, barcode, Warehouse_code FROM TMZ_List WHERE Warehouse_code = '$param'"";");
  var check = await db.query("TMZ_List");
  List<db_TMZ> list = res.isNotEmpty ? res.map((e) => db_TMZ.fromMap(e)).toList() : [];
  return list;
} 


 getAllTMZjson<String>(param) async{
  final db = await database;
  var res = await db.rawQuery("SELECT id, code, title, quantity, barcode, Warehouse_code FROM TMZ_List WHERE Warehouse_code = '$param'"";");
  
  return res.toString();
} 

UpdateTMZ(db_TMZ tmz) async{
 final db = await database;
 var res = await db.update("TMZ_List", tmz.toMap(), where: "id = ?", whereArgs: [tmz.id]);
 return res;
} 

deleteTMZ(db_TMZ tmz) async{
 final db = await database;
 return await db.delete("TMZ_List", where: "id = ?", whereArgs: [tmz.id]);
} 

deleteAllTMZ(param) async{
 final db = await database;
 return await db.delete("TMZ_List", where: "Warehouse_code = ?", whereArgs: [param]);
} 
 //Warehouse
 addWarehouse(db_Warehouse wrh) async{
  final db = await database;
  var raw = await db.rawInsert(
  " INSERT INTO Warehouse_List(code, title)"
  " VALUES (?,?)",
  [wrh.code, wrh.title], );
  return raw;
}

Future<List<db_Warehouse>> getAllWarehouse() async{
  final db = await database;
  var res = await db.query("Warehouse_List");
  List<db_Warehouse> list = res.isNotEmpty ? res.map((e) => db_Warehouse.fromMap(e)).toList() : [];
  return list;
} 
  
}