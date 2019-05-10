import 'package:flutter/material.dart';
import 'db.dart';
import 'newsDb.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'read.dart';
class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _DetailPage createState() => _DetailPage();
}
class _DetailPage extends State<DetailPage> {
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
  _DetailPage(){
//    getSources();
//  Source source = ModalRoute.of(context).settings.arguments;
//  print(source);
//  getNesData(source.url);
  }

  @override
  Widget build(BuildContext context) {
    News news=ModalRoute.of(context).settings.arguments;
    print(news.description);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('详情'),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
        child: Column(
          children: <Widget>[
            Text(news.title,style: TextStyle(fontSize: 25),),
            Text(news.pubDate,style: TextStyle(fontSize: 15),textAlign: TextAlign.right,),
            Html(data: news.description),
            FlatButton(onPressed: (){
//              print('opad');
              Navigator.of(context).push(

                  new MaterialPageRoute(builder: (context) {

                    return new NewsWebPage(news.guid,news.title);//link,title为需要传递的参数

                  },

                  ));
//              Navigator.of(context).pushNamed("url_read", arguments: news.guid);
//            return new WebviewScaffold(url: news.guid);
            }, child: Text('阅读更多。。。'))
          ],
        ),
      ),)
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}