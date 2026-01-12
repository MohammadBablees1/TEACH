import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teach/data/consts/app_const.dart';

class Sql {
  Database? database;
  Future<String> getDataBasePath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    return path;
  }
  /// الحصول على قاعدة البيانات (Lazy & Safe)
   Future<Database> get databaseFuture async {
    if (database != null) return database!;
    database = await openCurrentDatabase();
    return database!;
  }
  Future openCurrentDatabase() async {
    final databasePath = await getDataBasePath();

    return await openDatabase(
      databasePath,
      version: databaseVersion,
      onCreate: (databse, version) async {
        // create tables
        await databse.execute("create table mode (id text, night text)");
        await databse.execute("create table lan (id text, en text)");
      },
    );
  }

  Future lunchnightMode() async {
     final db = await databaseFuture;

    await db.insert("mode", {"id": "1", "night": "true"});
  }

  Future lunchEn() async {
    final db = await databaseFuture;

    await db.insert("lan", {"id": "1", "en": "true"});
  }

  // update section

  Future updateMode(mode) async {
     final db = await databaseFuture;
    await db.update("mode", {"id": "1", "night": '$mode'},
        where: " id = '1'");
  }

  Future updateLan(lan) async {
     final db = await databaseFuture;
    await db.update("lan", {"id": "1", "en": '$lan'}, where: " id = '1'");
  }

  // get section

  Future<List<Map>> getMode() async {
 final db = await databaseFuture;
    var mode = await db.rawQuery("select * from mode");

    return mode;
  }

  Future<List<Map>> getLan() async {
 final db = await databaseFuture;
    var lan = await db.rawQuery("select * from lan");

    return lan;
  }
}
