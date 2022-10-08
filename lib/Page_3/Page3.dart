
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference chat_list = FirebaseFirestore.instance.collection('chat_log');
  String my="";
  String you="";



  @override
  Widget build(BuildContext context) {
    MySharedPreferences.instance.getBooleanValue("isInflu").then((value) => setState(() {
      if(value){
        my="inf";
        you="spo";
      }else{
        my="spo";
        you="inf";
      }

    }));

    print(0);
    return Scaffold(


        body: StreamBuilder<dynamic>(

        stream: chat_list.where(my, isEqualTo: FirebaseAuth.instance.currentUser?.email.toString()).snapshots(),
        builder:(context,snapshot) {
          print(my);
          print(FirebaseAuth.instance.currentUser?.email.toString());

          if(!snapshot.hasData) {
            return Text("Loading");
          }
          print(snapshot.data.docs.length);
          print(2);
          return ListView.builder(

            //scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(5),
              itemCount: snapshot.data.docs.length,

              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFc9b9ec),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(children: [
                      Container(
                          height: 100,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Placeholder(
                              fallbackHeight: 100, fallbackWidth: 100)),
                      Column(children: [
                        Container(child: Text(snapshot.data!.docs[index][you])),
                        Container(child: Text(snapshot.data!.docs[index]['lastchat'])),

                      ]),
                    ]),
                  ),
                  onTap: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Page3Detail(snapshot.data!.docs[index][you],snapshot.data!.docs[index]['inf'],snapshot.data!.docs[index]['spo'],snapshot.data!.docs[index].id)));
                  },

                  onLongPress: () =>
                      showDialog(context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('다이얼로그 메시지'),

                              content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('testleft'),
                                      Text('testright')
                                    ],
                                  )
                              ),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                  setState(() {

                                    Navigator.of(context).pop();
                                  });
                                }, child: Text('ok')),
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('cancel'))
                              ],


                            );
                          }),
                );
              });
        })
    );
  }
}


