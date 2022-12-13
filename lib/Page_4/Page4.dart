import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_4/Page4_BlackList.dart';
import 'package:fzu/Page_4/Page4_LikeAd.dart';
import 'package:fzu/Page_4/Page4_LikeInfluencer.dart';
import 'package:fzu/Page_4/Page4_MyAd.dart';
import 'package:fzu/Page_4/Page4_FilteringTextList.dart';
import 'package:fzu/Page_4/Page4_Notice.dart';
import 'package:fzu/Page_4/Page4_manageInfoSponsor.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:package_info/package_info.dart';

import 'Page4_FAQ.dart';
import 'Page4_LikeSponsor.dart';
import 'Page4_manageInfoInfluencer.dart';

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

  //인증을 위한 이메일 보내기
  String user_email = FirebaseAuth.instance.currentUser!.email.toString();

  Future<String> _getEmailBody() async {
    String body = "";
    String type = "인플루언서";
    PackageInfo info = await PackageInfo.fromPlatform();
    MySharedPreferences.instance
        .getBooleanValue("isInflu")
        .then((value) =>
        setState(() {
          if (value == false) {
            type = "광고주";
          }
        }));

    body += "==============\n";
    body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다 \n";
    body += "이메일 : $user_email\n";
    body += "회원 타입 : $type\n";
    body += "Fzu 버전 : ${info.version}\n";
    body += "==============\n";
    if (type == "인플루언서") {
      body += "자신이 해당 채널 혹은 계정을 운영하고 있다는 증거와 사업자 등록증을 제출하주시길 바랍니다.";
    } else {
      body += "자신의 기업을 운영하고 있다는 증거와 사업자 등록증을 제출해 주시길 바랍니다.";
      body += "개인 사업자 일 경우, 사업자 등록번호 및 신분증을 제출해 주시길 바랍니다.";
    }

    return body;
  }

  void _sendEmail() async {
    String body = await _getEmailBody();
    final Email email = Email(
      body: body,
      subject: '[FZU 인증하기]',
      recipients: ['forcapstoneproject1@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = "오류";
      String message =
          "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nforcapstoneproject1@gmail.com";
      _showErrorAlertDialog(title, message);
    }
  }

  void _showErrorAlertDialog(String title, String message) {
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
                Text(title),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

// 인증을 위한 이메일 보내기


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                                const Base64Decoder().convert(_profileImage))
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
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 45,
                  padding: const EdgeInsets.all(3.5),
                  width: double.infinity,
                  decoration: const BoxDecoration(
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
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        topLeft: Radius.circular(6))),
                                child: isInflu
                                    ? const Text("관심 광고",
                                    style: TextStyle(
                                      color: Color(0xff9f83de),
                                      fontSize: 17,
                                    ))
                                    : const Text("등록 광고",
                                    style: TextStyle(
                                      color: Color(0xff9f83de),
                                      fontSize: 17,
                                    )),
                              ))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
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
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(6),
                                      topRight: Radius.circular(6)),
                                  color: Colors.white,
                                ),
                                child: isInflu
                                    ? const Text("관심 기업",
                                    style: TextStyle(
                                        color: Color(0xff9f83de),
                                        fontSize: 17))
                                    : const Text("관심 인플루언서",
                                    style: TextStyle(
                                        color: Color(0xff9f83de),
                                        fontSize: 17)),
                              ))),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 45,
                  padding: const EdgeInsets.all(3.5),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xff9f83de),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const Page4_FilteringTextList()));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        topLeft: Radius.circular(6))),
                                child: isInflu
                                    ? const Text("필터링 설정",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ))
                                    : const Text("필터링 설정",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    )),
                              ))),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
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
                                decoration: const BoxDecoration(
                                  //color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(6),
                                        topRight: Radius.circular(6))),
                                child: const Text("차단 목록",
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
                              style: const ButtonStyle(),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: const [
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
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: OutlinedButton(
                              style: const ButtonStyle(),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: const [
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
                              style: const ButtonStyle(),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: const [
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
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: OutlinedButton(
                              style: const ButtonStyle(),
                              onPressed: () {
                                _sendEmail();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: const [
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
                      child: const Text('내 정보 수정'),
                    )),
              ),
            ],
          ),
        ),

       floatingActionButton: SizedBox(
         width: 100, height: 50,
         child: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                onPressed: () {
                  signOutMethod(context);
                },
                child: const Text("Logout"),
              ),
       )
    );
  }

  void signOutMethod(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    MySharedPreferences.instance.setBooleanValue("loggedin", false);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MainLoginScreen()));
  }

  void showAddFilteringTextDialog() async {
    pwController.text = '';
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
                Text("비밀번호 확인"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "비밀번호를 입력해주세요.",
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      controller: pwController,
                      obscureText: true,
                    )),
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
                  AuthCredential credential = EmailAuthProvider.credential(email: _currentUser, password: pwController.text);
                  FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential).catchError((_) {
                    Fluttertoast.showToast(msg: '비밀번호가 올바르지 않습니다.');
                  }).then((value) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => isInflu ? Page4_manageInfoInfluencer(currentUser: _currentUser)
                            : Page4_manageInfoSponsor(currentUser: _currentUser,)));

                  });


                },
              ),
            ],
          );
        });
  }
}
