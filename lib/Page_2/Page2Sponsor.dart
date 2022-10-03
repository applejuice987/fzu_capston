import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Sponsor2.dart';
import 'package:fzu/Page_2/Page2Sponsor3.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor extends StatefulWidget {
  const Page2Sponsor({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor> createState() => _Page2SponsorState();
}

class _Page2SponsorState extends State<Page2Sponsor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            //const SliverAppBar(
              //title: Text("새로운 광고모집을 추가하세요"),
              //floating: true,
              //flexibleSpace: Placeholder(),
             // expandedHeight: 100,

           // ),
            SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Page2Sponsor3()));

                      }, child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: const Icon(
                          CupertinoIcons.plus,
                        ),),),
                      //CircleAvatar(
                        //radius: 30,
                       // backgroundColor: Colors.black,
                       // child: const Icon(
                         // CupertinoIcons.plus,
                       // ),),
                      Text("새로운 광고 모집하기"),

                    ],
                  ),
                )
            ),


            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text("광고 제목"),
                    onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Page2Sponsor2()));
                  },),
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
