import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

import 'Page_2/Page2Influencer_DetailAd.dart';
import 'Page_3/Page3Detail.dart';


class detailPage_Sponsor extends StatefulWidget {
  final String email;
  const detailPage_Sponsor({Key? key, required this.email}) : super(key: key);

  @override
  State<detailPage_Sponsor> createState() => _detailPage_SponsorState();
}

class _detailPage_SponsorState extends State<detailPage_Sponsor> {
  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  String company = '';
  String ceoName = '';
  String profile = '';
  List<dynamic> adList = [];
  bool isBlock = false;
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    db.collection('userInfoTable').doc('user').collection('user_sponsor').doc(widget.email).get().then((DocumentSnapshot ds) {
        setState(() {
          company = ds['company'];
          ceoName = ds['ceoName'];
          adList = ds['adList'];
          profile = ds['profile']; //프사
        });
    });
    db.collection('userInfoTable').doc('user').collection('user_influencer').doc(_currentUser).get().then((DocumentSnapshot ds) {
      setState((){
        if (ds["likeSpoList"].contains(widget.email)) {
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
                  "$company님을 차단합니다.\n차단 여부는 상대방이 알 수 없으며,\n"
                      "차단을 해제하기 전까지\n해당 사용자의 메시지를 차단하고\n해당 사용자 및 광고는 노출되지 않습니다.",
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
                  newBlackList.add(widget.email);
                  db.collection('userInfoTable').doc('user').collection('user_influencer').doc(_currentUser).update({
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
                  "$company님에게 다이렉트 메시지를 보냅니다.\n비밀번호나 주민등록번호 등 개인정보를 요구하는 경우\n"
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
                          builder: (context) => Page3Detail(widget.email, '$_currentUser${widget.email}')));
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
                          'user_influencer').doc(_currentUser).update(
                          {'likeSpoList': FieldValue.arrayRemove([widget.email])
                          });
                      isLiked = false;
                      Fluttertoast.showToast(msg: '관심 목록에서 제거되었어요.');
                    } else {
                      db.collection('userInfoTable').doc('user').collection(
                          'user_influencer').doc(_currentUser).update(
                          {'likeSpoList': FieldValue.arrayUnion([widget.email])
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          child: Container(
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
                        child: Text(company, textAlign: TextAlign.center,)),

                  ],
                ),
                Text('$company', style: TextStyle(fontSize: 40),),
                Text('사업자명 : $ceoName'),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width-60,
                    alignment: Alignment.centerLeft,
                    child: Text('등록 광고 목록', style: TextStyle(fontSize: 25),)),
                adList.isEmpty ? Text('아직 등록된 광고가 없습니다.')
                    : Container(
                      height: 65*adList.length.toDouble(),
                      child: ListView.separated(itemBuilder: (ctx, index) {
                  return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(adList[index].toString()),
                          OutlinedButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Page2Influencer2(applicant: adList[index],)));
                          }, child: Text('공고 보기'))
                        ],
                      ),
                  );
                }, separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1,
                  );
                }, itemCount: adList.length,
                      physics: NeverScrollableScrollPhysics(),),
                    ),
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
        ),
      ),
    );
  }
}
