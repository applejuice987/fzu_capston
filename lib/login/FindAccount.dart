import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 계정 찾기. BUT 회원가입때 사용한 이메일을 가지고 만들것이기 때문에,
//TODO!! 이메일은 무조건 알고 있어야하고, 비밀번호는 찾기 시 초기화 시켜줌.

class FindAccount extends StatefulWidget {
  const FindAccount({Key? key}) : super(key: key);

  @override
  State<FindAccount> createState() => _FindAccountState();
}

class _FindAccountState extends State<FindAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Text("비밀번호 찾기 화면")),
    );
  }
}
