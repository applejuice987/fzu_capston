import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_1/Create_Info.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page1Influencer extends StatefulWidget {
  const Page1Influencer({Key? key}) : super(key: key);

  @override
  State<Page1Influencer> createState() => _Page1InfluencerState();
}

class _Page1InfluencerState extends State<Page1Influencer> {

  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  String _prImage = '';
  String _prText = '';
  String _prAny = '';
  String _displayName = '';
  String _profileImage = '';
  bool _isOnlyImage = false;
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    db.collection('userInfoTable').doc('user').collection('user_influencer').doc(_currentUser).get().then((DocumentSnapshot ds) {
      setState(() {
        _displayName = ds['displayName'];
        print(ds['displayName']);
        _prImage = ds['PRImage'];
        _prText = ds['PRText'];
        _isOnlyImage = ds['isOnlyImage'];
        _prAny = ds['PRAny'];
        _profileImage = ds['profile'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xC9B9EC),
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget> [
          Text('$_displayName님 환영합니다!'),
            Text('현재 설정한 프로필'),
            _isOnlyImage ? Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              alignment: Alignment.center,
              child:
              _prImage != '' ? Image.memory(Base64Decoder().convert(_prImage))
                  : Text('아직 설정하신 이미지가 없습니다.'),
              //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
            )
            : Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.55,
                        height: MediaQuery.of(context).size.width*0.55,
                        alignment: Alignment.center,
                        child:
                      _prImage != '' ? Image.memory(Base64Decoder().convert(_prImage))
                          : Text('아직 설정하신 이미지가 없습니다.'),
                        //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
                      ),
                      Container(
                        width: 100,
                        height: MediaQuery.of(context).size.width*0.55,
                        alignment: Alignment.center,
                        child: _prAny != '' ? Text(_prAny)
                            : Text("아직 설정하신 추가내용이 없습니다."),
                      )
                    ],
                  ),
                  _prText != '' ? Text(_prText)
                      : Text("아직 설정하신 인사말이 없습니다.")
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: FittedBox(
                child: FloatingActionButton.extended(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Create_Info(prImage: _prImage, prText: _prText, prAny: _prAny, isOnlyImage: _isOnlyImage,)));
                },
                label: Text('홍보 설정하기'),),
              ),
            )
          ]
          ),
      ),
      );
  }
}
