import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_influencer/SignUpInfluencer.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 인플루언서 로그인과 회원가입을 실행할 수 있음.

class LoginInfluencer extends StatefulWidget {
  const LoginInfluencer({Key? key}) : super(key: key);

  @override
  State<LoginInfluencer> createState() => _LoginInfluencerState();
}

class _LoginInfluencerState extends State<LoginInfluencer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpInfluencer()));
              }, child: Text("회원가입")),
              TextButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()),(Route<dynamic> route) => false);
              }, child: Text("메인으로 넘어가기")),
            ],
          )),
    );
  }
}
