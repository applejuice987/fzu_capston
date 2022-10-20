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

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

  FirebaseAuth auth = FirebaseAuth.instance;

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.lightBlue,
          ),
          Text(auth.currentUser!.email.toString()),
          SizedBox(
            child: ElevatedButton(onPressed: () {
              signOutMethod(context);
            } , child: const Text("로그아웃")),
          ),
        ],
      ),
    );
  }

  void signOutMethod(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    MySharedPreferences.instance.setBooleanValue("loggedin", false);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    const MainLoginScreen()));
  }
}
