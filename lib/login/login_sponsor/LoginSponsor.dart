import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 여기서 광고주 로그인과 회원가입을 실행할 수 있음.

class LoginSponsor extends StatefulWidget {
  const LoginSponsor({Key? key}) : super(key: key);

  @override
  State<LoginSponsor> createState() => _LoginSponsorState();
}

class _LoginSponsorState extends State<LoginSponsor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Text("스폰서 로그인")),
    );
  }
}
