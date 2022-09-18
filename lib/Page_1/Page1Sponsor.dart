import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fzu/Page_1/influItem.dart';









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
  get bottomNavigationBar => null;

  @override
  Widget build(BuildContext context) {
    InfluList = influList?.fromJson(influItem);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                alignment: AlignmentDirectional.center,
                child: Text('광고모델 모집하기',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4),
              ),


              Image.asset(InfluList!.list!.elementAt(0).image!),  //influList 의 0번째 요소의 image
              Text(InfluList!.list!.elementAt(0).name!),  //influList 의 0번째 요소의 name

            ]
        ),
      ),
    );
  }

}
