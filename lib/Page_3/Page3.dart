import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 모든 채팅창 출력
//TODO!! 3초 이상 누르면 삭제 하는 다이얼로그 출력

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final List<String> entries = <String>['A', 'N','tt','rr','A', 'N','tt','rr','A', 'N','tt','rr','A', 'N','tt','rr'];
  final List<String> en = <String>['B', 'C','g','rr','A', 'N','tt','rr','A', 'N','tt','rr','A', 'N','tt','rr'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(5),
            itemCount: en.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                        width: MediaQuery.of(context).size.width,
                        child: Row(children: [
                          Container(
                            height:100,
                              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Placeholder(
                                  fallbackHeight: 100, fallbackWidth: 100)),
                          Column(children: [
                            Container(child: Text("${en[index]}")),
                            Container(child: Text("${entries[index]}")),
                          ])
                        ,
                        ]),

                      );

            }));
  }

  Scaffold buildScaffold() {
    return Scaffold(
      body: Column(children: <Widget>[
        Row(children: [
          Container(
              width: 100,
              child: Placeholder(fallbackHeight: 100, fallbackWidth: 100)),
          Column(children: [
            Container(child: const Text('이름 및 별명')),
            Container(child: const Text('마지막채팅'))
          ])
        ])
      ]),
    );
  }
}
