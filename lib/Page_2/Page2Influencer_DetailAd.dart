//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Influencer2 extends StatefulWidget {
  const Page2Influencer2({Key? key}) : super(key: key);

  @override
  State<Page2Influencer2> createState() => _Page2Influencer2State();
}


class _Page2Influencer2State extends State<Page2Influencer2> {
  final _nameController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;


  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();


  @override

  CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');
  CollectionReference user = FirebaseFirestore.instance.collection('userInfoTable');

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          child: Column(
            children: [
              Text("회사명"),
              Text("제목"),

              Text("내용"),

            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              //height: submitButtonHeigh,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1,
                ),
                child: Text('지원하기'),

              ),
            ),
          ),
        ),
      ),
    );
  }
}