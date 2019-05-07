import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String tableName = 'sources';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnUrl = 'url';
final String columnFavicon = 'favicon';

class Source{
  int id ;
  String title;
  String url;
  String favicon;

  Source(String title,String url ,String favicon){
//    this.id = id;
    this.title = title;
    this.url = url;
    this.favicon = favicon;
  }
  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      columnTitle: title,
      columnUrl: url,
      columnFavicon: favicon
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
  Source.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    url = map[columnUrl];
    favicon = map[columnFavicon];
  }

}

class SourceData {
  Database db;
   openDb() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'rssplus.db');
    db = await openDatabase(path,version: 1,onCreate: (Database db,int version) async{
      await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT,
            $columnUrl TEXT,
            $columnFavicon TEXT)
          ''');
    });
  }
  Future <Source> insert(Source source) async{
    source.id = await db.insert(tableName, source.toMap());
    return source;
  }
  Future<List<Source>> queryAll() async {
    List<Map> maps = await db.query(tableName, columns: [
      columnId,
      columnUrl,
      columnFavicon,
      columnTitle
    ]);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<Source> sources = [];
    for (int i = 0; i < maps.length; i++) {
      sources.add(Source.fromMap(maps[i]));
    }
    return sources;
  }
  Future<Source> getSource(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnTitle,
          columnFavicon,
          columnUrl
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Source.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Source source) async {
    return await db.update(tableName, source.toMap(),
        where: '$columnId = ?', whereArgs: [source.id]);
  }
  Future<Source> getSourceByTitle(String title) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnTitle,
          columnFavicon,
          columnUrl
        ],
        where: '$columnTitle = ?',
        whereArgs: [title]);
    if (maps.length > 0) {
      return Source.fromMap(maps.first);
    }
    return null;
  }

  close() async {
    await db.close();
  }
}