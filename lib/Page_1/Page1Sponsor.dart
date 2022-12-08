import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/rendering/object.dart';

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();
}

enum category { Car, Game, Phone, Song, Clothing, All }

class _Page1SponsorState extends State<Page1Sponsor> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController _controller = PageController();

  int _Count = 0;
  var _isChecked = false;
  category _Cate = category.Car;

  void _incrementCounter() {
    setState(() {
      _Count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffC9B9EC),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('자동차'),
                      value: category.Car,
                      groupValue: _Cate,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _Cate = value as category;
                        });
                      }),
                ),
                Expanded(
                  child: RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('핸드폰'),
                      value: category.Phone,
                      groupValue: _Cate,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _Cate = value as category;
                        });
                      }),
                ),
                Expanded(
                  child: RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('옷'),
                      value: category.Clothing,
                      groupValue: _Cate,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _Cate = value as category;
                        });
                      }),
                ),
              ]),

/*
      Expanded(child:
      RadioListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text('노래'),
                value: category.Song,
                groupValue: _Cate,
                onChanged: (value){
                  setState(() {
                    if (value !=null) _Cate = value as category;
                  });
                }),
      ) */

              Container(
                margin: EdgeInsets.only(top: 35),
                alignment: AlignmentDirectional.center,
                child: Text('광고모델 모집하기',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('userInfoTable')
                        .doc('user')
                        .collection('user_influencer')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }

                      final docs = snapshot.data!.docs;
                      return SizedBox(
                        height: 600,
                        child: PageView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            pageSnapping: true,
                            physics: ScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    docs[index]['isOnlyImage'] ? Container(
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child:
                                      docs[index]['PRImage'] != '' ? Image.memory(Base64Decoder().convert(docs[index]['PRImage']))
                                          : Text('아직 설정하신 이미지가 없습니다.'),
                                      //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
                                    )
                                        : Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.55,
                                                height: MediaQuery.of(context).size.width*0.55,
                                                alignment: Alignment.center,
                                                child:
                                                docs[index]['PRImage'] != '' ? Image.memory(Base64Decoder().convert(docs[index]['PRImage']))
                                                    : Text('아직 설정하신 이미지가 없습니다.'),
                                                //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
                                              ),
                                              Container(
                                                width: 100,
                                                height: MediaQuery.of(context).size.width*0.55,
                                                alignment: Alignment.center,
                                                child: docs[index]['PRAny'] != '' ? Text(docs[index]['PRAny'])
                                                    : Text("아직 설정하신 추가내용이 없습니다."),
                                              )
                                            ],
                                          ),
                                          docs[index]['PRText'] != '' ? Text(docs[index]['PRText'])
                                              : Text("아직 설정하신 인사말이 없습니다.")
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          docs[index]['email'],
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            docs[index]['platform'],
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            docs[index]['subscribers'],
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            docs[index]['category'].toString(),
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {}, child: Text('자세히 보기'))
                                  ],
                                ),
                              );
                            }),
                      );
                    }),
              )
            ],
          ),
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
