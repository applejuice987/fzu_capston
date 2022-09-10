import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 로그인 한 사람의 프로필 수정이라던가 이것저것 만들 예정.

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("네 번째 페이지 입니다."),
      ),
    );
  }
}
