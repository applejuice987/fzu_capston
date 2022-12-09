import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

//TODO!! 로그인의 관계 없이 같은 화면 출력
//TODO!! 로그인 한 사람의 프로필 수정이라던가 이것저것 만들 예정.

class Page4_Notice extends StatefulWidget {
  const Page4_Notice({Key? key}) : super(key: key);

  @override
  State<Page4_Notice> createState() => _Page4_NoticeState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _Page4_NoticeState extends State<Page4_Notice> {
  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  List<String> _value = [];

  //List<String> _noticeList = [];
  Map<String, List<String>> notice = {};

  @override
  void initState() {
    super.initState();
    db
        .collection('noticeTable')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      setState(() {
        for (var doc in value.docs) {
          List<String> _noticeList = [];
          _noticeList.clear();
          print('${notice.values}dsfsdfsd');
          _noticeList.add(doc['category']);
          _noticeList.add(doc['content'].toString().replaceAll('nn', '\n'));
          _noticeList.add(doc['date']);
          print(_noticeList);
          print(notice.values);
          notice.putIfAbsent(doc.id, () => _noticeList);

          print(notice);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '공지사항',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
          margin: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
              itemBuilder: (ctx, index) {
                return Container(
                  //margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  //height: 72,
                  //alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Text(
                                      notice.values.elementAt(index)[0],
                                      style: TextStyle(
                                          fontSize: 11, color: Color(0x88000000)),
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Text(
                                        notice.keys.elementAt(index).toString(), style: TextStyle(fontSize: 15),)),
                                Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: Text(
                                      notice.values.elementAt(index)[2],
                                      style: TextStyle(
                                          fontSize: 9, color: Color(0x66000000)),
                                    )),

                              ],
                            ),
                          ),
                          IconButton(onPressed: () {
                            setState(() {
                              if (_value.contains(notice.keys.elementAt(index).toString())) {
                                _value.remove(notice.keys.elementAt(index).toString());
                              } else {
                                _value.add(notice.keys.elementAt(index).toString());
                              }
                            });
                          }, icon: Icon(_value.contains(notice.keys.elementAt(index).toString()) ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined))
                        ],
                      ),
                      Visibility(visible:
                      _value.contains(notice.keys.elementAt(index).toString()), child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                            color: Color(0x11000000),
                              alignment: Alignment.centerLeft,
                              child: Text(notice.values.elementAt(index)[1])),
                        ],
                      ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                );
              },
              itemCount: notice.length)),
    );
  }
}
