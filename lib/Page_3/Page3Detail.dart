import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'chatMessageModel.dart';

//TODO!! Page3에서 클릭 하였을때, 누른 1:1 채팅창의 화면 출력.

class Page3Detail extends StatefulWidget {
  const Page3Detail({Key? key}) : super(key: key);

  @override
  State<Page3Detail> createState() => _Page3DetailState();
}

List<ChatMessage> messages = [
  ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
  ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
];

class _Page3DetailState extends State<Page3Detail> {
  final input_text = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController _controller=ScrollController();

// This is what you're looking for!


  String opponent_email='spo@spo.com';
  //StreamController<String> streamController = StreamController<String>();
  CollectionReference chat_log = FirebaseFirestore.instance.collection('chat_log').doc(FirebaseAuth.instance.currentUser?.email.toString()).collection('spo@spo.com');
  List<DocumentSnapshot> item = [];
  @override

  Widget build(BuildContext context) {
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

              //stream: streamController.stream,
                stream: chat_log.snapshots(),


                builder: (context,snapshot){
                   //_scrollDown();


                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  print(snapshot.data.docs.length);

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
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (snapshot.data.docs[index]['sender_email'] ==
                                    opponent_email ? Alignment.topLeft : Alignment
                                    .topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (snapshot.data.docs[index]['sender_email'] ==
                                        opponent_email ? Colors.grey.shade200 : Colors
                                        .blue[200]),
                                  ),

                                  padding: EdgeInsets.all(16),
                                  //child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                                  child: Text(snapshot.data!.docs[index]['chat'],
                                    style: TextStyle(fontSize: 15),),

                                ),
                              ),
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
                              child: Text("Powered By:",
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
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
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
                    onPressed: (){

                      firestore.collection('chat_log').doc(opponent_email).collection(FirebaseAuth.instance.currentUser!.email.toString()).doc(DateTime.now().toString()).set({
                        'sender_email':FirebaseAuth.instance.currentUser?.email.toString(),
                        'chat':input_text.text
                      });
                      firestore.collection('chat_log').doc(FirebaseAuth.instance.currentUser?.email.toString()).collection(opponent_email).doc(DateTime.now().toString()).set({
                        'sender_email':FirebaseAuth.instance.currentUser?.email.toString(),
                        'chat':input_text.text
                      });


                      input_text.text="";
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
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
