import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page2Influencer extends StatefulWidget {
  const Page2Influencer({Key? key}) : super(key: key);

  @override
  State<Page2Influencer> createState() => _Page2InfluencerState();
}

class _Page2InfluencerState extends State<Page2Influencer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("새로운 광고모집을 추가하세요"),
              floating: true,
              flexibleSpace: Placeholder(),
              expandedHeight: 100,
            ),
          SliverList(
        delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text("광고 제목")),
    childCount: 20,
    ),
          ),
    ],
        ),
      ),
    );
  }
}






