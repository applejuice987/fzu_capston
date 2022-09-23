import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fzu/Page_1/influItem.dart';

final influItem = {
  "list": [
    {"image": "images/Samsung.png", "name": "삼성"},
    {"image": "images/Lg.png", "name": "엘지"},
    {"image": "images/Hyundai.png", "name": "현대"},
    {"image": "images/Kia.png", "name": "기아"}
  ]
};
influList? InfluList;


//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page1Influencer extends StatefulWidget {
  const Page1Influencer({Key? key}) : super(key: key);

  @override
  State<Page1Influencer> createState() => _Page1SponsorState();
}

class _Page1SponsorState extends State<Page1Influencer> {
  @override
  Widget build(BuildContext context) {
    InfluList = influList?.fromJson(influItem);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.cyan[700],
        body: SafeArea(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 35),
              alignment: AlignmentDirectional.center,
              child:
                  Text('스폰서 보기', style: Theme.of(context).textTheme.headline4),
            ),
            Expanded(
              child: PageView.builder(
                controller: PageController(
                  initialPage: 0, //시작 페이지
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          height: 200,
                          child: Image.asset(
                            InfluList!.list!.elementAt(index).image!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: Container(
                            color: Colors.blue,
                            child: Text(
                              InfluList!.list!.elementAt(index).name!,
                            ),
                          ))
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
        bottomNavigationBar: SafeArea(
            child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.subtitle1),
          child: Text('매칭하기'),
        )),
      ),
    );
  }
}
