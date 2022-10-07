import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Influencer2.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page2Influencer extends StatefulWidget {
  const Page2Influencer({Key? key}) : super(key: key);

  @override
  State<Page2Influencer> createState() => _Page2InfluencerState();
}

class _Page2InfluencerState extends State<Page2Influencer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1/1.5),
          children: List.generate(100, (index) {
            return Container(
              child: InkWell(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Page2Influencer2()));
                },
              child: Container(
                height: 1000,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    CircleAvatar(radius: 70,),
                    SizedBox(height: 20,),
                    Text('광고명'),
                    Text('회사명'),
                ],
                ),
            ),
              ),
            );
          }

          ),
        )
    );
  }
}






