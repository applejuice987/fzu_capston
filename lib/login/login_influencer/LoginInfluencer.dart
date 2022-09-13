import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          child: Text("인플루언서 로그인")),
    );
  }
}
