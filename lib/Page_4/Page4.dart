import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_4/Page4_BlackList.dart';
import 'package:fzu/Page_4/Page4_LikeAd.dart';
import 'package:fzu/Page_4/Page4_LikeInfluencer.dart';
import 'package:fzu/Page_4/Page4_MyAd.dart';
import 'package:fzu/Page_4/Page4_FilteringTextList.dart';
import 'package:fzu/Page_4/Page4_Notice.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

import 'Page4_FAQ.dart';
import 'Page4_LikeSponsor.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 로그인 한 사람의 프로필 수정이라던가 이것저것 만들 예정.

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _Page4State extends State<Page4> {
  var db = FirebaseFirestore.instance;
  bool isInflu = true;
  String _currentUser = '';
  String _profileImage = '';
  String self_auth = '';
  String _collectionPath = '';
  List<dynamic> _filteringTextList = [];

  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    self_auth = '인증 완료';
    //TODO 본인인증완료 여부 확인하는 코드 작성

    MySharedPreferences.instance
        .getBooleanValue("isInflu")
        .then((value) => setState(() {
          isInflu = value;
      if (value) {
        _collectionPath = 'user_influencer';
        db
            .collection('userInfoTable')
            .doc('user')
            .collection('user_influencer')
            .doc(_currentUser)
            .get()
            .then((DocumentSnapshot ds) {
          _profileImage = ds['profile'].toString();
          _filteringTextList = ds['filteringTextList'];
          print(_filteringTextList.toString());
          print('1234');
        });
      } else {
        _collectionPath = 'user_sponsor';
        db
            .collection('userInfoTable')
            .doc('user')
            .collection('user_sponsor')
            .doc(_currentUser)
            .get()
            .then((DocumentSnapshot ds) {
          _filteringTextList = ds['filteringTextList'];
          print(_filteringTextList.toString());
          print('1234');
          if (ds['profile'] != '') {
            _profileImage = ds['profile'].toString();
          }
        });
      }
            }));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.lightBlue,
                      child: ClipOval(
                          child: _profileImage != ''
                              ? Image.memory(
                                  Base64Decoder().convert(_profileImage))
                              : Image.asset(
                                  "assets/images/default_profile_image.jpg"))),
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text(_currentUser), Text(self_auth)],
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 45,
                padding: EdgeInsets.all(3.5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff9f83de),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                            onTap: isInflu
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Page4_LikeAd()));
                                  }
                                : () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Page4_MyAd()));
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      topLeft: Radius.circular(6))),
                              child: isInflu
                                  ? Text("관심 광고",
                                      style: TextStyle(
                                        color: Color(0xff9f83de),
                                        fontSize: 17,
                                      ))
                                  : Text("등록 광고",
                                      style: TextStyle(
                                        color: Color(0xff9f83de),
                                        fontSize: 17,
                                      )),
                            ))),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(width: 2)),
                    Expanded(
                        child: InkWell(
                            onTap: isInflu
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Page4_LikeSponsor()));
                                  }
                                : () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Page4_LikeInfluencer()));
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: Colors.white,
                              ),
                              child: isInflu
                                  ? Text("관심 기업",
                                      style: TextStyle(
                                          color: Color(0xff9f83de),
                                          fontSize: 17))
                                  : Text("관심 인플루언서",
                                      style: TextStyle(
                                          color: Color(0xff9f83de),
                                          fontSize: 17)),
                            ))),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 45,
                padding: EdgeInsets.all(3.5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff9f83de),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                            onTap:  () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const Page4_FilteringTextList()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      topLeft: Radius.circular(6))),
                              child: isInflu
                                  ? Text("필터링 설정",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ))
                                  : Text("필터링 설정",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  )),
                            ))),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(width: 2, color: Colors.white,)),
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                          context) => const Page4_BlackList()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(6),
                                      topRight: Radius.circular(6))),
                              child: Text("차단 목록",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                            ))),
                  ],
                )),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Page4_Notice()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '공지사항',
                                  style: TextStyle(
                                      color: Color(0xff9f83de), fontSize: 20),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey,
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: OutlinedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Page4_FAQ()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'FAQ',
                                  style: TextStyle(
                                      color: Color(0xff9f83de), fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 20.0, color: Colors.grey)
                              ],
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            style: ButtonStyle(),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '이용안내',
                                  style: TextStyle(
                                      color: Color(0xff9f83de), fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 20.0, color: Colors.grey)
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: OutlinedButton(
                            style: ButtonStyle(),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '인증센터',
                                  style: TextStyle(
                                      color: Color(0xff9f83de), fontSize: 20),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 20.0, color: Colors.grey)
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 90,
              child: Expanded(
                  child: OutlinedButton(
                onPressed: () {},
                child: Text('내 정보 수정'),
              )),
            ),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    signOutMethod(context);
                  },
                  child: const Text("로그아웃")),
            ),
          ],
        ),
      ),
    );
  }

  void signOutMethod(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    MySharedPreferences.instance.setBooleanValue("loggedin", false);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MainLoginScreen()));
  }
}
