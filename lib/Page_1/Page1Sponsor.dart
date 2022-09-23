import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fzu/Page_1/influItem.dart';
import 'package:flutter/src/rendering/box.dart';

final influItem = {
  "list": [
    {"image": "images/lee.jpg", "name": "이정재"},
    {"image": "images/park.jpg", "name": "박은빈"},
    {"image": "images/kim.jpg", "name": "김연아"},
    {"image": "images/son.jpg", "name": "손흥민"}
  ]
};
influList? InfluList;

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();
}

class _Page1SponsorState extends State<Page1Sponsor> {
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
              child: Text('광고모델 모집하기',
                  style: Theme.of(context).textTheme.headline4),
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
                            child: Text(InfluList!.list!.elementAt(index).name!,),
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
    ),
    );
  }
}
