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

class Page4_FilteringTextList extends StatefulWidget {
  const Page4_FilteringTextList({Key? key}) : super(key: key);

  @override
  State<Page4_FilteringTextList> createState() => _Page4_FilteringTextListState();
}

FirebaseAuth auth = FirebaseAuth.instance;


class _Page4_FilteringTextListState extends State<Page4_FilteringTextList> {

  var db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';
  List<dynamic> _filteringTextList = [];
  String _userPath = '';

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.getBooleanValue("isInflu").then((value) =>
        setState(() {
          if (value) {
            _userPath = 'user_influencer';
          } else {
            _userPath = 'user_sponsor';
          }

        })).then((value) {
      db.collection('userInfoTable').doc('user').collection(_userPath).doc(_currentUser).get().then((DocumentSnapshot doc) {
        setState(() {
          _filteringTextList = doc['filteringTextList'];
        });

      });
    });
    _currentUser = auth.currentUser!.email.toString();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('필터링 설정', style: TextStyle(color: Colors.black),),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.add
                ),
              )
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,

      ),
      body:
          Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: _filteringTextList.isEmpty ? Text('특정 단어를 등록하여 차단할 수 있어요.')
            : ListView.separated(itemBuilder: (ctx, index) {
              return Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_filteringTextList![index].toString()),
                    TextButton(onPressed: () {
                      setState(() {
                        List<dynamic> t = [];
                        String filteringText = _filteringTextList[index];
                        t.add(_filteringTextList[index]);
                        db.collection('userInfoTable').doc('user').collection(_userPath).doc(_currentUser).update({'filteringTextList' : FieldValue.arrayRemove(t)
                      });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$filteringText 단어의 차단이 해제되었습니다.")));
                        _filteringTextList.removeAt(index);

                      });
                    }, child: Text('해제'))
                  ],
                ),
              );
            }, separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
              );
            }, itemCount: _filteringTextList!.length)
          ),

    );
  }

}
