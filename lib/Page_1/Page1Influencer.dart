import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page1Influencer extends StatefulWidget {
  const Page1Influencer({Key? key}) : super(key: key);

  @override
  State<Page1Influencer> createState() => _Page1InfluencerState();
}

class _Page1InfluencerState extends State<Page1Influencer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[700],
      body: Center(
        child:
        Text('인플루언서 1페이지')
        ),
      );

  }
}
