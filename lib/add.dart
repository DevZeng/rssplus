import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'db.dart';
import 'package:fluttertoast/fluttertoast.dart';


class addDialog extends Dialog{
  SourceData sourceData = new SourceData();
  String url;
  addDialog({
    Key key,
    this.url
  }) : super(key: key);

  getRssData(url)  {
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
      try {
        Dio().request(url).then((response){
          if(response.statusCode==200){

          }else{
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
        }).catchError((DioError e){
          Fluttertoast.showToast(
              msg: "网络错误，请检查RSS源地址！",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0
          );
        });
      } catch (e) {
        print(e);
        print('ERRPR');
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
//                            var db = new SourceData();
//                            db.openDb();
//                            print(db.queryAll());
                            getSources();
                            Navigator.of(context).pop();
                          }, child:
                          Text('取消'))
                          ,
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width-68)/2,
                          child: FlatButton(onPressed: (){
                            print(this.url);
                            getRssData(this.url);
//                            saveSource();
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
  saveSource()async{
    await sourceData.openDb();
    await sourceData.insert(new Source("flutter大全0","flutter","中国出版"));
    await sourceData.close();
  }
  getSources()async{
    await sourceData.openDb();
    List<Source> returns = await sourceData.queryAll();
    await sourceData.close();
    print(returns[0].url);
  }

}

