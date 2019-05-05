import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class addDialog extends Dialog{
  String url;
  addDialog({
    Key key,
    this.url
  }) : super(key: key);

  getRssData(url) {
    var data ;
    Dio().request(url).then((response){
      if(response.statusCode==200){
        data = response.data;
      }
    });
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
                            print(getRssData(this.url));
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
}

