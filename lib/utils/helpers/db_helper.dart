import 'dart:io';

import 'package:exam/screen/home/model/db_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DbHelper{
  static DbHelper dbHelper=DbHelper._();
  DbHelper._();
   Database? dataBase;
  Future<Database?> checkDB()
  async {
    if(dataBase!=null) {
      return dataBase;
    }
    else{
      dataBase=await initDB();
      return dataBase;
    }
  }
  Future<Database> initDB() async {
    Directory d1=await getApplicationSupportDirectory();
    String path=d1.path;
    String joinPath=join(path,"quotes.db");
    return openDatabase(joinPath,onCreate: (db, version) {
      db.execute('CREATE TABLE contact(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT,mobile TEXT)');
    },version: 1);
  }
  Future<void> addData(DBModel model)
  async {
    dataBase=await checkDB();
    await dataBase!.insert("contact", {"name": model.name,"email":model.email,"mobile":model.mobile});
  }
  Future<void> updateData(DBModel model)
  async {
    dataBase=await checkDB();
    await dataBase!.update("contact", {"name": model.name,"email":model.email,"mobile":model.mobile},where: "id=?",whereArgs: [model.id]);
  }
  Future<void> deleteData(int id)
  async {
    dataBase=await checkDB();
    await dataBase!.delete("contact",where: "id=?",whereArgs: [id]);
  }
  Future<List<DBModel>> readData() async {
    dataBase = await checkDB();
    List<Map> dataList=await dataBase!.rawQuery("SELECT * FROM contact");
    List<DBModel> dbList=[];
    dbList=dataList.map((e) => DBModel.mapToModel(e),).toList();
    return dbList;
  }
}
