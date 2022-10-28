import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_3/Page3Detail.dart';
import 'dart:io';

//TODO!! 로그인의 관계 없이 같은 화면 출력

//TODO!! 모든 채팅창 출력
//TODO!! 3초 이상 누르면 삭제 하는 다이얼로그 출력
class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String my = "";
  String you = "";
  String yourimage = "";
  String email="";

  void initState() {

    super.initState();
    email=FirebaseAuth.instance.currentUser!.email.toString()!;
    MySharedPreferences.instance.getBooleanValue("isInflu").then((value) =>
        setState(() {
          if (value) {
            my = "inf";
            you = "spo";
            yourimage = "spoimage";
          } else {
            my = "spo";
            you = "inf";
            yourimage = "infimage";
          }
        }));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: StreamBuilder<dynamic>(

            stream: FirebaseFirestore.instance.collection(
                'chat_log').where(my, isEqualTo: email)
                .snapshots(),

            builder: (context, snapshot) {


              if (!snapshot.hasData) {
                return
                  Container(
                    child: Center(
                      child: SizedBox(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFc9b9ec))),
                          height: 100,
                          width: 100
                      ),

                    ),
                  );
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(






                  //scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(5),
                  itemCount: snapshot.data.docs.length,

                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(


                      title: Container(

                        decoration: BoxDecoration(
                          color: Color(0xFFc9b9ec),
                          // borderRadius: BorderRadius.circular(30),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Row(children: <Widget>[

                          Container(

                              padding: EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                  radius: 50,
                                  // child:Text
                                  backgroundImage: MemoryImage(
                                    Base64Decoder().convert(
                                        snapshot.data.docs[index][yourimage]),
                                  )

                              )
                          )
                          ,

                          Column(children: [
                            Container(
                                child: Text(snapshot.data!.docs[index][you])),
                            Container(child: Text(
                                snapshot.data!.docs[index]['lastchat'])),

                          ]),
                        ]),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>
                                Page3Detail(snapshot.data!.docs[index][you],
                                    snapshot.data!.docs[index].id)));
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


