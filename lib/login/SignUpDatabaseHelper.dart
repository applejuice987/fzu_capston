import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import '../main.dart';


class SignUpDatabaseHelper {
  String _currentUser = '';
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = auth.currentUser!.email.toString(); //로그인 EMail 확인

  }

  Future<void> backUpInfluencerData(String email,String pw, String platform, String img) async{ //데이터 백업 함수
      final backUpData = <String, dynamic>{ //SQLite 데이터 매핑
        'email': email,
        'pw': pw,
        'platform': platform,
        'profile' : img,
      };
      db.collection("userInfoTable").doc("dummy").collection("user_influencer").doc(email).set(backUpData);
  }

  Future<void> backUpSponsorData(String email,String pw, String company, String image ) async{ //데이터 백업 함수
    final backUpData = <String, dynamic>{ //SQLite 데이터 매핑
      'email': email,
      'pw': pw,
      'company': company,
      'profile' : image,
    };
    db.collection("userInfoTable").doc("dummy").collection("user_sponsor").doc(email).set(backUpData);
  }

  Future<void> loginFunc(String email, String pw, BuildContext context, bool isInflu) async{
    try {
      final newUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: pw);
      //TODO!! 나중에 각주 삭제 1
      // if(newUser.user?.emailVerified == true){
        if (newUser.user != null) {
          MySharedPreferences.instance.setBooleanValue("loggedin", true);
          MySharedPreferences.instance.setBooleanValue("isInflu", isInflu);
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyApp()),
                  (Route<dynamic> route) => false);
        }
        //TODO!! 나중에 각주 삭제 2
      // }
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이메일 인증을 진행해주세요!")));
      //   FirebaseAuth.instance.signOut();
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainLoginScreen()),(Route<dynamic> route) => false);
      //
      // }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이메일을 확인하세요")));
        //flutterToast('이메일을 확인하세요.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("비번을 확인하세요")));
        //flutterToast('비밀번호를 확인하세요.');
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이메일 형식이 잘못되었습니다.")));
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("사용할 수 없는 계정입니다.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("오류가 발생했습니다. 다시 시도해주세요.")));
      }
    }

  }

  Future<void> resetPassword(String email, BuildContext context) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) =>
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10.0)),
              title: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("완료"),
                ],),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("이메일을 확인해주세요.")
                ],),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("확인"),
                ),
              ]);
    }));
  }

  void flutterToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

}
