import 'package:flutter/material.dart';
import 'add.dart';
import 'db.dart';
import 'newsDb.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:shared_preferences/shared_preferences.dart';
class newsListPage extends StatefulWidget {
  newsListPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _newsListPage createState() => _newsListPage();
}
class _newsListPage extends State<newsListPage> {
  int _counter = 0;
  int sourceId = 0;
  String sourceUrl ;
  List<News> newses = [];
  SourceData sourceData = new SourceData();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  _newsListPage(){
//    getSources();
//  Source source = ModalRoute.of(context).settings.arguments;
//  print(source);
//  getNesData(source.url);
  }
  getDate(String name)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String date = prefs.get(name);
    return date;
  }
  getNesData() async {
    var data ;
    List <News> v = [];
    try{
      await Dio().request(sourceUrl).then((response){
        if(response.statusCode==200){
          var xmlContent = response.data;
          var document = xml.parse(xmlContent);
          document.findAllElements('item').forEach((ele){
            String desc = '';
            desc = ele.findAllElements('description').length==0?'':ele.findAllElements('description').single.text;
//            print(ele.findAllElements('description').first.text);
            News news = new News(null, ele.findAllElements('title').single.text,
                ele.findAllElements('link').single.text,
                desc,
                ele.findAllElements('pubDate').single.text,
                ele.findAllElements('guid').single.text,
                0,
                sourceId);
            v.add(news);
          });
        }

      });
    }catch(e) {

    }
//    print('v');
//    print(v);
    return v;
  }

  @override
  Widget build(BuildContext context) {
    Source source=ModalRoute.of(context).settings.arguments;
    sourceId = source.id;
    sourceUrl = source.url;
//    getNesData(source.url,9);
//    print(args);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('列表'),
      ),
     body: RefreshIndicator(child: ListView.separated(itemBuilder:(context, index){
       return ListTile(
         title: Text(newses[index].title),
         onTap: (){
           Navigator.of(context).pushNamed("detail_page", arguments: newses[index]);
         },
       );
     }, separatorBuilder: (context, index) => Divider(height: .0), itemCount: newses==null?0:newses.length),
     onRefresh: _onRefresh,),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Future < void > _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      getNesData().then((v){
        setState(() {
          newses = v;
        });
      });
    });
  }
}