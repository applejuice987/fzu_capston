import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 모든 채팅창 출력
//TODO!! 3초 이상 누르면 삭제 하는 다이얼로그 출력

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("세 번째 페이지 입니다."),
      ),
    );
  }
}
