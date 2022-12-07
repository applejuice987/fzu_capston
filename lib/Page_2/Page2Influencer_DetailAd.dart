import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fzu/Page_3/Page3Detail.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Influencer2 extends StatefulWidget {
  final String applicant;

  const Page2Influencer2({Key? key, required this.applicant}) : super(key: key);

  @override
  State<Page2Influencer2> createState() => _Page2Influencer2State();
}

class _Page2Influencer2State extends State<Page2Influencer2> {
  final _nameController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();

  //final applicant = ModalRoute.of(context)!.settings.arguments as applicant;

  String _title = '';
  String _content = '';
  String _email = '';
  String _image = '';
  String _duration = '';
  String _profile = '';
  String _company = '';
  String _currentUser = '';
  dynamic _applicant = [];
  String _buttonText = '지원하기';
  bool _isAfterDate = false;
  late DateTime startDate;
  late DateTime endDate;
  CollectionReference adtable =
      FirebaseFirestore.instance.collection('AdTable');
  CollectionReference user =
      FirebaseFirestore.instance.collection('userInfoTable');

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
                  "$_email님에게 다이렉트 메시지를 보냅니다.\n모집 광고 '$_title'를 통해 진행되며,\n비밀번호나 주민등록번호 등 개인정보를 요구하는 경우\n"
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Page3Detail(_email, '${_currentUser}${_email}')));
                  //Navigator.pop(context);
//                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    print(widget.applicant);
    _currentUser = auth.currentUser!.email.toString();
    adtable.doc(widget.applicant).get().then((DocumentSnapshot ds) {
      setState(() {
        _title = ds['title'];
        _content = ds['content'];
        _email = ds['email'];
        _image = ds['image'];
        _applicant = ds['applicant'];
        _duration = ds['duration'];
        List<String> Detailduration = _duration.split(" ");
        startDate = DateTime.parse(Detailduration[0]);
        endDate = DateTime.parse(Detailduration[2]);
        if (startDate.isAfter(DateTime.now())) {
          _isAfterDate = true;
          _buttonText = '아직 모집 기간이 아닙니다.';
        }

        if (DateTime.now().isAfter(endDate)) {
          _isAfterDate = true;
          _buttonText = '모집이 종료되었습니다.';
        }
      });
    }).then((value) {
      user.doc('user').collection('user_sponsor').doc(_email).get().then((DocumentSnapshot ds) {
        setState(() {
          _profile = ds['profile'];
          _company = ds['company'];
        });

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            _title,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5,
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
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
                                child: _profile != ''
                                    ? Image.memory(
                                    Base64Decoder().convert(_profile))
                                    : Image.asset(
                                    "assets/images/default_profile_image.jpg"))),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_company),
                          Text(_email)
                        ],
                      )
                    ],
                  ),
                ),
                Image.memory(Base64Decoder().convert(_image)),

                Container(
                  width: double.infinity,
                    child: Text(_title, style: TextStyle(fontSize: 30),)),
                Text(_content),
                //Text(_email),
                Text('모집 기간 : $_duration')
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              //height: submitButtonHeigh,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    child: ElevatedButton(
                      onPressed: _isAfterDate ? null
                        : () {
                        if (_applicant.contains(auth.currentUser!.email.toString())) {
                          Fluttertoast.showToast(msg: "이미 지원하신 광고입니다.");
                        } else {
                          adtable.doc(widget.applicant).update({
                            'applicant': FieldValue.arrayUnion([docId])
                          });
                          Fluttertoast.showToast(msg: "지원이 완료되었습니다.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                      child: Text(_buttonText),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.4,
                      child: ElevatedButton(onPressed: () {
                        showChatWtihSponsorDialog();
                      }, child: Text('DM')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
