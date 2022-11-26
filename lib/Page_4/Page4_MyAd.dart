import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 로그인 한 사람의 프로필 수정이라던가 이것저것 만들 예정.

class Page4_MyAd extends StatefulWidget {
  const Page4_MyAd({Key? key}) : super(key: key);

  @override
  State<Page4_MyAd> createState() => _Page4_MyAdState();
}

FirebaseAuth auth = FirebaseAuth.instance;


class _Page4_MyAdState extends State<Page4_MyAd> {

  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  List<dynamic> _myAdList = [];

  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    db.collection('sponsor').doc(_currentUser).collection('recruit').get().then((event) {
      setState(() {
        for (var doc in event.docs) {
          _myAdList.add(doc['title']);
        }
      });
    });
    print(_myAdList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('등록 광고 목록', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body:
          Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: _myAdList.isEmpty ? Text('아직 등록하신 광고가 없어요.\n광고모델 모집을 위해 광고를 등록해주세요!')
            : ListView.separated(itemBuilder: (ctx, index) {
              return Container(
                height: 70,
                child: Text(_myAdList![index].toString()),
              );
            }, separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
              );
            }, itemCount: _myAdList!.length)
          ),

    );
  }

}
