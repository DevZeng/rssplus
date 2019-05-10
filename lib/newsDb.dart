import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String tableName = 'news';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnLink = 'link';
final String columnDesc = 'description';
final String columnDate = 'pubDate';
final String columnGuid = 'guid';
final String columnRead = 'read';
final String columnSource = 'source';

class News{
  int id ;
  String title;
  String link;
  String description;
  String pubDate;
  String guid;
  int read;
  int source;

  News(int id,String title,String link ,String description,String pubDate,String guid,int read,int source){
    this.id = id;
    this.title = title;
    this.link = link;
    this.description = description;
    this.pubDate = pubDate;
    this.guid = guid;
    this.read = read;
    this.source = source;
  }
  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      columnTitle: title,
      columnDate: pubDate,
      columnDesc: description,
      columnGuid: guid,
      columnLink: link,
      columnRead: link,
      columnSource: source,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
  News.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    link = map[columnLink];
    guid = map[columnGuid];
    description = map[columnDesc];
    pubDate = map[columnDate];
    read = map[columnRead];
    source = map[columnSource];
  }

}

class NewsData {
  Database db;
  openDb() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'rssplus.db');
    db = await openDatabase(path,version: 1,onCreate: (Database db,int version) async{
      await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnRead INTEGER,
            $columnSource INTEGER,
            $columnTitle TEXT,
            $columnDesc TEXT,
            $columnGuid TEXT,
            $columnDate TEXT,
            $columnLink TEXT)
          ''');
    });
  }
  Future <News> insert(News news) async{
    news.id = await db.insert(tableName, news.toMap());
    return news;
  }
  Future<List<News>> queryAll() async {
    List<Map> maps = await db.query(tableName, columns: [
      columnId,
      columnDate,
      columnGuid,
      columnTitle,
      columnDesc,
      columnLink,
      columnRead,
      columnSource,
    ]);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<News> newses = [];
    for (int i = 0; i < maps.length; i++) {
      newses.add(News.fromMap(maps[i]));
    }
    return newses;
  }
  Future<News> getNews(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnDate,
          columnGuid,
          columnTitle,
          columnDesc,
          columnLink,
          columnRead,
          columnSource,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return News.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(News news) async {
    return await db.update(tableName, news.toMap(),
        where: '$columnId = ?', whereArgs: [news.id]);
  }
  Future<List<News>> queryAllBySource(int source) async {
    List<Map> maps = await db.query(tableName, columns: [
      columnId,
      columnDate,
      columnGuid,
      columnTitle,
      columnDesc,
      columnLink,
      columnRead,
      columnSource,
    ],where: '$columnSource = ?',
    whereArgs: [source]);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<News> newses = [];
    for (int i = 0; i < maps.length; i++) {
      newses.add(News.fromMap(maps[i]));
    }
    return newses;
  }
  close() async {
    await db.close();
  }
}