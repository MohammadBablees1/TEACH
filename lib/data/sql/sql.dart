import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/sql_const.dart';

class Sql {
  late Database database;
  Future<String> getDataBasePath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);
    return path;
  }

  Future openCurrentDatabase() async {
    final databasePath = await getDataBasePath();

    database = await openDatabase(
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
    await openCurrentDatabase();

    await database.insert("mode", {"id" : "1" ,"night" : "true"
    });
  }

  Future lunchEn() async {
    await openCurrentDatabase();

    await database.insert("lan", {"id" : "1" ,"en" : "true"
    });
  }



  // update section

  Future updateMode(mode) async {
    openCurrentDatabase();
    await database.update("mode", {
      "id" : "1",
      "night" : '$mode'
    },
        where: " id = '1'");
  }

  Future updateLan(lan) async {
    openCurrentDatabase();
    await database.update("lan", {
      "id" : "1",
      "en" : '$lan'
    },
        where: " id = '1'");
  }
 
  // get section
  

  Future<List<Map>> getMode() async {
    openCurrentDatabase();
    var mode = await database.rawQuery("select * from mode");

    return mode;
  }

  Future<List<Map>> getLan() async {
    openCurrentDatabase();
    var lan = await database.rawQuery("select * from lan");

    return lan;
  }

}
