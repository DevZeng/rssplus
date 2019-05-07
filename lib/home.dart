import 'package:flutter/material.dart';
import 'add.dart';
import 'db.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Source> sources;
  SourceData sourceData = new SourceData();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  _MyHomePageState(){
    getSources();
  }
  getSources()async{
    await sourceData.openDb();
    List<Source> returns = await sourceData.queryAll();
    await sourceData.close();
    setState(() {
//      print(returns.length);
      sources = returns;
    });
  }
  delSource(int id) async {
    await sourceData.openDb();
    await sourceData.delete(id);
    await sourceData.close();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(widget.title),
      ),
      body:ListView.separated(
        itemCount: sources==null?0:sources.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network("${sources[index].favicon}"),
            title: Text("${sources[index].title}"),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
              delSource(sources[index].id);
              sources.remove(sources[index]);
              setState(() {
                sources = sources;
              });
            }),
            onLongPress: (){
              print('TEST');
              showDialog<Null>(
                context: context,
                builder: (BuildContext context) {
                  return new SimpleDialog(
                    title: new Text('操作'),
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text('删除'),
                        onPressed: () {
                          delSource(sources[index].id);
                          sources.remove(sources[index]);
                          setState(() {
                            sources = sources;
                          });
//                          SourceData().delete(id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ).then((val) {
//                print(val);
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(height: .0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void showAddDialog(){
    print('opan');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new addDialog();
      }
    );
  }


}