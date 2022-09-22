import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page2Sponsor extends StatefulWidget {
  const Page2Sponsor({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor> createState() => _Page2SponsorState();
}

class _Page2SponsorState extends State<Page2Sponsor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("스폰서 두 번째 페이지 입니다."),
      ),
    );
  }
}
