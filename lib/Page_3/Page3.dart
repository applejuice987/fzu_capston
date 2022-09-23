

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_3/Page3Detail.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력

//TODO!! 모든 채팅창 출력
//TODO!! 3초 이상 누르면 삭제 하는 다이얼로그 출력

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final List<String> entries = <String>['A', 'N', 'tt', 'rr', 'A', 'N', 'tt', 'rr', 'A', 'N', 'tt', 'rr', 'A', 'N', 'tt', 'rr'
  ];
  final List<String> en = <String>[
    'B', 'C', 'g', 'rr', 'A', 'N', 'tt', 'rr', 'A', 'N', 'tt', 'rr', 'A', 'N', 'tt', 'rr'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(5),
            itemCount: en.length,

            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Placeholder(
                            fallbackHeight: 100, fallbackWidth: 100)),
                    Column(children: [
                      Container(child: Text("${en[index]}")),
                      Container(child: Text("${entries[index]}")),
                    ]),
                  ]),

                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Page3Detail()));
                },

                onLongPress: ()=> showDialog(context: context,
                    barrierDismissible: false,
                    builder:(BuildContext context){
                      return AlertDialog(
                        title:Text('다이얼로그 메시지'),

                        content:SingleChildScrollView(
                          child:ListBody(
                            children: <Widget>[
                              Text('testleft'),
                              Text('testright')
                            ],
                          )
                        ),
                        actions: <Widget>[
                          TextButton(onPressed:(){
                            setState(() {
                              en.removeAt(index);
                              Navigator.of(context).pop();

                            });
                          }, child: Text('ok')),
                          TextButton(onPressed:(){
                            Navigator.of(context).pop();
                          }, child: Text('cancel'))
                        ],


                      );

                    }),
              );
            }));
  }
}


