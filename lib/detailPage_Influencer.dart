import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

import 'Page_3/Page3Detail.dart';


class detailPage_Influencer extends StatefulWidget {
  final String email;
  const detailPage_Influencer({Key? key, required this.email}) : super(key: key);

  @override
  State<detailPage_Influencer> createState() => _detailPage_InfluencerState();
}

class _detailPage_InfluencerState extends State<detailPage_Influencer> {
  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  String channelName = '';
  String contents = '';
  String displayName = '';
  String platform = '';
  String profile = '';
  String email = '';
  String subscribers = '';
  List<dynamic> category = [];
  bool isBlock = false;
  bool isLiked = false;
  List<String> likeList = [];
  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    db.collection('userInfoTable').doc('user').collection('user_influencer').doc(widget.email).get().then((DocumentSnapshot ds) {
        setState(() {
          channelName = ds['channelName']; //채널
          contents = ds['contents']; //주 컨텐츠
          displayName = ds['displayName']; //닉네임
          platform = ds['platform']; //플랫폼
          email = ds['email'];
          profile = ds['profile']; //프사
          subscribers = ds['subscribers']; //구독자팔로워 등
          category = ds['category']; //카테고리 리스트
        });
    });
    db.collection('userInfoTable').doc('user').collection('user_sponsor').doc(_currentUser).get().then((DocumentSnapshot ds) {
      setState((){
        if (ds["likeInfList"].contains(widget.email)) {
          isLiked = true;
        }
      });
    });
  }

  void showBlockInfluencerDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text("차단하시겠습니까?"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$displayName님을 차단합니다.\n차단 여부는 상대방이 알 수 없으며,\n"
                      "차단을 해제하기 전까지\n해당 사용자의 메시지를 차단하고\n해당 사용자는 노출되지 않습니다.",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    isBlock = true;
                  });
                  List<String> newBlackList = [];
                  newBlackList.add(email);
                  db.collection('userInfoTable').doc('user').collection('user_sponsor').doc(_currentUser).update({
                    'blackList' : FieldValue.arrayUnion(newBlackList)
                  });
                  Fluttertoast.showToast(msg: '차단이 완료되었습니다.');
//                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void showChatWtihSponsorDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text("DM을 시작합니다."),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$displayName님에게 다이렉트 메시지를 보냅니다.\n비밀번호나 주민등록번호 등 개인정보를 요구하는 경우\n"
                      "개인정보 유출에 주의해주세요.",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Page3Detail(email, '$email$_currentUser')));
                  //Navigator.pop(context);
//                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('상세정보', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (isLiked) {
                    db.collection('userInfoTable').doc('user').collection(
                        'user_sponsor').doc(_currentUser).update(
                        {'likeInfList': FieldValue.arrayRemove([email])
                        });
                    isLiked = false;
                    Fluttertoast.showToast(msg: '관심 목록에서 제거되었어요.');
                  } else {
                    print('notlike');
                    db.collection('userInfoTable').doc('user').collection(
                        'user_sponsor').doc(_currentUser).update(
                        {'likeInfList': FieldValue.arrayUnion([email])
                        });
                    Fluttertoast.showToast(msg: '관심 목록에 추가되었어요.');
                    isLiked = true;
                  }
                });
              },
              icon: isLiked ? Image.asset("assets/images/heart_full_icon_black.png")
                  : Image.asset("assets/images/heart_empty_icon_black.png"),
              iconSize: 26.0,
            )
        ),],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.lightBlue,
                        child: ClipOval(
                            child: profile != ''
                                ? Image.memory(
                                Base64Decoder().convert(profile))
                                : Image.asset(
                                "assets/images/default_profile_image.jpg")))),
                Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width-140,
                    child: Text(channelName, textAlign: TextAlign.center,)),

              ],
            ),
            Text('$platform 인플루언서', style: TextStyle(fontSize: 40),),
            Text('활동 플랫폼 : $platform'),
            Text('활동명 : $channelName'),
            Text('구독자(팔로워) 수 : $subscribers'),
            Text('주 콘텐츠 : $contents'),
            Text('카테고리 : $category'),
            Text('연락처 : $email'),
            Row(

              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      showBlockInfluencerDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                    ),
                    child: Text('차단하기'),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: ElevatedButton(onPressed: () {
                      showChatWtihSponsorDialog();
                    }, child: Text('DM 보내기')))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
