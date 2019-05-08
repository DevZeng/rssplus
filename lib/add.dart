import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
//import 'package:matcher/mirror_matchers.dart';



class addDialog extends Dialog {
  String sourceUrl = 'u';
  String sourceTitle = 'y';
  String sourceFavicon = 'f';
  int sourceId = 0;
  SourceData sourceData = new SourceData();
  String url;
  addDialog({
    Key key,
    this.url
  }) : super(key: key);

  getRssData(String url,BuildContext context) {
    var data ;
    if(url==null){
      Fluttertoast.showToast(
          msg: "URL不能为空！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0
      );
    }else{
        Dio().request(url).then((response){
          if(response.statusCode==200){
            var xmlContent = response.data;
            var document = xml.parse(xmlContent);
            var isXml = document.findAllElements('rss');
            if(isXml == null){
              Fluttertoast.showToast(
                  msg: "不是有效的RSS源！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  fontSize: 16.0
              );
            }
            var title = document.findAllElements('title').first.text;
            var getUrl = document.findAllElements('link').first.text;
            Source source = new Source(0,title, url, getUrl+'/favicon.ico');
            sourceUrl = getUrl;
            sourceTitle = title;
            sourceFavicon = getUrl+'/favicon.ico';
            getSourceByTitle(title).then((val){
              if(val != null){
                print(val);
                Fluttertoast.showToast(
                    msg: "已存在的RSS源！",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black,
                    fontSize: 16.0
                );
              }else{
                saveSource(source).then((val){
                  print(val);
                  Navigator.of(context).pop(new Source(val,sourceTitle, sourceUrl, sourceFavicon));
                });
              }
            });
          }else{
            print(response.statusCode);
            Fluttertoast.showToast(
                msg: "网络错误，请检查RSS源地址！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 16.0
            );
          }
        }).catchError((e){
          print(e.runtimeType);
          if(e is xml.XmlParserException){
            Fluttertoast.showToast(
                msg: "不是有效的RSS源！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 16.0
            );
          }
          if(e is DioError){
            Fluttertoast.showToast(
                msg: "网络错误，请检查网络或RSS源地址！",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 16.0
            );
          }
        });

    }


    return data;
  }

  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(12),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                decoration: ShapeDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ))),
                margin: const EdgeInsets.all(12.0),
                child: new Column(children: <Widget>[
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10.0, 40.0, 10.0, 28.0),
                      child: Center(
                          child: new Text('请输入地址',
                              style: new TextStyle(
                                fontSize: 20.0,
                              )))),
                  new Padding(padding: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (v){
                      this.url = v;
                    },
                  )),
                  new Padding(padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width-68)/2,
                          child: FlatButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child:
                          Text('取消'))
                          ,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width-68)/2,
                          child: FlatButton(onPressed: (){
                            print(this.url);
                            getRssData(this.url,context);

                          }, child:
                          Text('确认'))
                          ,
                        ),
                      ],
                    ),)
//                  new Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.max,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        TextFormField()
////                        TextField()
//                      ])

                ])),
          ],
        ),
      ),
    );
  }
  saveSource(Source source)async{
    await sourceData.openDb();
    await sourceData.insert(source);
    await sourceData.close();
  }
  getSources()async{
    await sourceData.openDb();
    List<Source> returns = await sourceData.queryAll();
    await sourceData.close();
    print(returns[0].url);
  }
  Future<Source> getSourceByTitle(String title) async {
    await sourceData.openDb();
    Source source = await sourceData.getSourceByTitle(title);
    await sourceData.close();
    return source;
  }

}

