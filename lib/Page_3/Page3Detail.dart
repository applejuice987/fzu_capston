import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'chatMessageModel.dart';

//TODO!! Page3에서 클릭 하였을때, 누른 1:1 채팅창의 화면 출력.

class Page3Detail extends StatefulWidget {
  final String roomid;
  final String origin_opponent_email;

  const Page3Detail(this.origin_opponent_email,this.roomid,{Key? key}) : super(key: key);
  @override
  State<Page3Detail> createState() => _Page3DetailState();
}

class _Page3DetailState extends State<Page3Detail> {
  List<dynamic> _adList = [];

  final input_text = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController _controller=ScrollController();
  bool _visibility= false;
// This is what you're looking for!


  String _currentUser = FirebaseAuth.instance.currentUser!.email.toString();
  String inf = '';
  String spo = '';
  String infImage = '';
  String spoImage = '';
  String myImage='';
  String yourImage='';
  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection('chat_log').doc(widget.roomid).get().then((DocumentSnapshot doc){
      _adList = doc['adList'];
    });
    MySharedPreferences.instance.getBooleanValue('isInflu').then((value) {
      setState(() {
        if (value) {
          inf = _currentUser;
          spo = widget.roomid.replaceAll(_currentUser, "");
        } else {
          spo = _currentUser;
          inf = widget.roomid.replaceAll(_currentUser, "");
        }
      });

    }).then((value) {
      firestore.collection('userInfoTable').doc('user').collection('user_sponsor').doc(spo).get().then((DocumentSnapshot ds) {
        setState(() {
          spoImage = ds['profile'];
        });

      });
      firestore.collection('userInfoTable').doc('user').collection('user_influencer').doc(inf).get().then((DocumentSnapshot ds) {
        setState(() {
          infImage = ds['profile'];
        });
      });
    });



  }

  //StreamController<String> streamController = StreamController<String>();

  @override


  Widget build(BuildContext context) {

    String opponent_email = widget.origin_opponent_email;
    String room = widget.roomid;
    CollectionReference chat_log = FirebaseFirestore.instance.collection('chat_log').doc(room).collection('dummy');

    String adlistMessage = '진행중인 광고건목록은\n';
    for(int i=0;i<_adList.length;i++)
      {
        adlistMessage += _adList[i].toString();
        adlistMessage +='\n';

      }
    adlistMessage +='입니다.';




    return Scaffold(
      appBar: AppBar(
        title:Text(opponent_email)
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap:(){

              FocusScope.of(context).unfocus();


            },
            child:StreamBuilder<dynamic>(


                stream: chat_log.snapshots(),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_controller.hasClients) {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    }
                  });
                  return SingleChildScrollView(


                    controller: _controller,


                    child: Column(

                      children: <Widget>[
                        ListView.builder( //채팅내용 출력
                          //itemCount: messages.length,
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {


                            return Container(
                              color:Colors.white10,
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),

                                child: Row(
                                  mainAxisAlignment : (snapshot.data.docs[index]['sender_email'] ==
                                      opponent_email ?  MainAxisAlignment.start : MainAxisAlignment.end),

                                    children: [
                                      Visibility(child: CircleAvatar(


                                        radius: 20,
                                        // child:Text
                                        backgroundImage: (_currentUser==inf ?  MemoryImage(
                                          Base64Decoder().convert(spoImage),
                                        ) : MemoryImage(
                                          Base64Decoder().convert(infImage),
                                        ))


                                    ),
                                      visible:(snapshot.data.docs[index]['sender_email'] ==
                                          opponent_email ? true : false),
                                    ),

                                  Container(
                                    margin:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (snapshot.data.docs[index]['sender_email'] ==
                                          opponent_email ? Colors.grey.shade200 : Color(0xFFc9b9ec)),
                                    ),

                                    padding: EdgeInsets.all(16),
                                    //child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                                    child: Text(snapshot.data!.docs[index]['chat'],
                                      style: TextStyle(fontSize: 15),),

                                  ),
                                      Visibility(child: CircleAvatar(

                                          radius: 20,
                                          // child:Text
                                          backgroundImage: (_currentUser==inf ?  MemoryImage(
                                            Base64Decoder().convert(infImage),
                                          ) : MemoryImage(
                                            Base64Decoder().convert(spoImage),
                                          ))

                                      ),
                                          visible:(snapshot.data.docs[index]['sender_email'] ==
                                              opponent_email ? false : true),
                                      )


                                ],


                                )

                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 18, bottom: 18),
                              child: Text("",
                                  style: new TextStyle(fontSize: 18.0)),
                            )
                          ],
                        ),
                      ],
                    ),
                  );


                }
            ),
          ),

          Align(//채팅 메세지 입력
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    },
                    child: Tooltip(
                      message:
                      adlistMessage,


                      triggerMode:
                      TooltipTriggerMode.tap,
                      showDuration:
                      Duration(seconds: 15),
                      child:
                      Icon(Icons.question_mark,color:Color(0xFFc9b9ec)),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(

                    child: TextField(


                      controller: input_text,
                      decoration: InputDecoration(


                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: () {
                      if (input_text.text != "") {
                        firestore.collection('chat_log').doc(room).collection(
                            'dummy').doc(DateTime.now().toString()).set({
                          'sender_email': FirebaseAuth.instance.currentUser
                              ?.email.toString(),
                          'chat': input_text.text
                        });
                        firestore.collection('chat_log').doc(room).update({
                          'lastchat': input_text.text,

                        }).catchError((e) {
                          if (e.toString() ==
                              '[cloud_firestore/not-found] Some requested document was not found.') {
                            firestore.collection('chat_log').doc(room).set({
                              'inf': inf,
                              'spo': spo,
                              'infimage': infImage,
                              'spoimage': spoImage,
                              'lastchat': input_text.text
                            });
                          }
                        });


                        input_text.text = "";
                      }
                    },

                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor:Color(0xFFc9b9ec),

                    elevation: 0,
                  ),

                ],

              ),
            ),
          ),
        ],
      ),

    );
}
}
