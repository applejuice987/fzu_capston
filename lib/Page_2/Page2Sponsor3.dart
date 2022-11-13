//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Sponsor2.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor3 extends StatefulWidget {
  const Page2Sponsor3({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor3> createState() => _Page2Sponsor3State();
}
class sponsorup {
  final String title;
  final String content;
  final String id;

  sponsorup({
    required this.title,
    required this.content,
    required this.id,
  });

  sponsorup.fromJson(Map<String, dynamic> json):
        title= json['title'],
        content = json['content'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'id': id,
  };


}

class _Page2Sponsor3State extends State<Page2Sponsor3> {
  final _nameController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;


  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');
  CollectionReference user = FirebaseFirestore.instance.collection('userInfoTable');

  //void getdata() {
  //var db = FirebaseFirestore.instance;
  // db.collection("sponsor").get().then((value) {
  // for (var doc in value.docs) {
  //  String title = doc["title"];
  //  String content = doc["content"];
  // }
  // })
  // }


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          child: Column(
            children: [
              Text("제목"),
              TextFormField(
                onChanged: (value) {titlebox = value;},
              ),
              Text("내용"),
              TextFormField(
                controller: _nameController,
                maxLength: 1000,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  hintStyle: Theme
                      .of(context)
                      .textTheme
                      .bodyText2,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),

                ),
                onChanged: (value){contentbox = value;},
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              //height: submitButtonHeigh,
              child: ElevatedButton(
                onPressed: (){
                  sponsorup sponsorModel1 = sponsorup(title: titlebox, content: contentbox, id: docId);
                  sponsor.doc(docId).collection('recruit').doc(titlebox).set(sponsorModel1.toJson());
                  user.doc('user').collection('user_sponsor').doc(docId)
                      .update({'adList':FieldValue.arrayUnion([titlebox])});
                  sponsor.doc('fullad').update({'adList':FieldValue.arrayUnion([titlebox])});
                  sponsor.doc('fullad').collection('recruit').doc(titlebox).set(sponsorModel1.toJson());

                  Navigator.pop(context);
                  //sponsor.add({'title': '제목1', 'content': '내용1'});

                },
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1,
                ),
                child: Text('등록하기'),

              ),
            ),
          ),
        ),
      ),
    );
  }
}