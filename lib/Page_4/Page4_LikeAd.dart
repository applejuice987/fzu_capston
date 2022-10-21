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

class Page4_LikeAd extends StatefulWidget {
  const Page4_LikeAd({Key? key}) : super(key: key);

  @override
  State<Page4_LikeAd> createState() => _Page4_LikeAdState();
}

FirebaseAuth auth = FirebaseAuth.instance;


class _Page4_LikeAdState extends State<Page4_LikeAd> {

  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  List<dynamic> _likeAdList = [];

  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    db.collection('userInfoTable').doc('user').collection('user_influencer').doc(_currentUser).get().then((DocumentSnapshot doc) {
      setState(() {
        _likeAdList = doc['likeAdList'];
      });
    });
    print(_likeAdList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('관심 광고 목록', style: TextStyle(color: Colors.black),),
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
            child: _likeAdList.isEmpty ? Text('아직 관심있게 본 광고가 없어요.\n관심있는 광고에 관심 버튼을 눌러 나만의 위시리스트를 만들어보세요!')
            : ListView.separated(itemBuilder: (ctx, index) {
              return Container(
                height: 70,
                child: Text(_likeAdList![index].toString()),
              );
            }, separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
              );
            }, itemCount: _likeAdList!.length)
          ),

    );
  }

}
