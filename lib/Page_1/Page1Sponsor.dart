import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();

}

class _Page1SponsorState extends State<Page1Sponsor> {
  @override
  Widget build(BuildContext context) {
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
            child: Text('광고모델 모집하기', style: Theme
                .of(context)
                .textTheme
                .headline4
            ),
            ),
             Container(
               margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),

               alignment: AlignmentDirectional.topEnd
             ,child: CircleAvatar(
              radius: 10,
              child: CupertinoButton(
                onPressed: () {},
                child: const Icon(CupertinoIcons.photo_camera_solid,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
             ),
            Center(
              child: CircleAvatar(
                radius: 40,
                child: CupertinoButton(
                  onPressed: () {},
                  child: const Icon(CupertinoIcons.photo_camera_solid,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Text('이름', style: Theme
                .of(context)
                .textTheme
                .subtitle1),
            Text('채널명', style: Theme
                .of(context)
                .textTheme
                .subtitle1),
            Text('구독자수', style: Theme
                .of(context)
                .textTheme
                .subtitle1),
            Text('주요 플랫폼', style: Theme
                .of(context)
                .textTheme
                .subtitle1)


          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .subtitle1
            ),
            child: Text('매칭하기'),

          )



    ));
  }

}
