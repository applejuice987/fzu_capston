import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/rendering/box.dart';
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
                                    Container(
                                        padding: EdgeInsets.all(20.0),
                                        child: Container(
                                            child: Image.memory(Base64Decoder()
                                                .convert(
                                                    docs[index]['profile']))
                                            //Base64Decoder().convert(docs['profile'])
                                            )),
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
                                            docs[index]['Subscribers'],
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            docs[index]['Category'],
                                            style: TextStyle(fontSize: 15.0),
                                          )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {}, child: Text('자세히보기'))
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
