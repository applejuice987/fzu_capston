<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> origin/jeongYeon_8th
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class Page2Sponsor_DetailAd extends StatefulWidget {
  final String title;

  const Page2Sponsor_DetailAd({Key? key, required this.title})
      : super(key: key);

  @override
  State<Page2Sponsor_DetailAd> createState() => _Page2Sponsor_DetailAdState();
}

class _Page2Sponsor_DetailAdState extends State<Page2Sponsor_DetailAd> {
<<<<<<< HEAD

  CollectionReference AdTable = FirebaseFirestore.instance.collection('AdTable');
  List<String> _applicantList= [];

  @override

  void setData() {
    AdTable.get().then((value) {
      setState(() {
        _applicantList.clear();
        for (var doc in value.docs) {
          print(doc['title']);
          _applicantList.add(doc['title'].toString());
        }
      });
    });
  }
=======
  FirebaseAuth auth = FirebaseAuth.instance;

  String _title = '';
  String _content = '';
  String _email = '';
  String _image = '';
  String _duration = '';
  String _profile = '';
  String _company = '';
  String _currentUser = '';
  List<dynamic> _applicant = [];
  String _buttonText = '지원하기';
  bool _isAfterDate = false;
  late DateTime startDate = DateTime(0000);
  late DateTime endDate;
  String _StartDate_YMD = '';
  String _EndDate_YMD = '';
  CollectionReference adtable =
      FirebaseFirestore.instance.collection('AdTable');
  CollectionReference user =
      FirebaseFirestore.instance.collection('userInfoTable');

  // DocumentReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    print(widget.title);
    _currentUser = auth.currentUser!.email.toString();
    adtable.doc(widget.title).get().then((DocumentSnapshot ds) {
      setState(() {
        _title = ds['title'];
        _content = ds['content'];
        _email = ds['email'];
        _image = ds['image'];
        _applicant = ds['applicant'];
        _duration = ds['duration'];
        List<dynamic> Detailduration = _duration.split(" ");
        startDate = DateTime.parse(Detailduration[0]);
        endDate = DateTime.parse(Detailduration[2]);

        _StartDate_YMD =
            "${startDate.year}년 ${startDate.month}월 ${startDate.day}일";
        _EndDate_YMD = "${endDate.year}년 ${endDate.month}월 ${endDate.day}일";
      });
    }).then((value) {
      user
          .doc('user')
          .collection('user_sponsor')
          .doc(_email)
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          _profile = ds['profile'];
          _company = ds['company'];
        });
      });
    });
  }
  void showDeletingDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text("삭제하기"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center
              ,
              children: const <Widget>[
                Text(
                  "공고를 삭제하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("취소", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("확인",style: TextStyle(color: Colors.black),),
                onPressed: () {
                  adtable.doc(widget.title).delete();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                          (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }
>>>>>>> origin/jeongYeon_8th

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: const Color(0xffc9b9ec),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xffc9b9ec),
        title: const Text(
          "FZU",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDeletingDialog();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Container(
            padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
            // height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "기간",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("$_StartDate_YMD + $_EndDate_YMD",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: _image.isNotEmpty ? true : false,
                    child: Image.memory(const Base64Decoder().convert(_image))),
                const SizedBox(
                  height: 15,
                ),
                Text(_content,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal)),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
          const SliverPersistentHeader(
              pinned: true, delegate: CategoryBreadcrumbs()),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("$index")));
                        },
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          // 보는 재미를 위해 인덱스에 아무 숫자나 곱한 뒤 255로
                          // 나눠 다른 색이 보이도록 함.
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: Colors.blue[100 * (index % 9 + 1)],
                            child: _applicant.length == 0 ? Text("지원자가 없습니다.") : Text(_applicant![index]),
                          ),
                        ),
                      ),
                  childCount: _applicant.length == 0 ? 1 : _applicant.length )),
        ],
      ),
    );
  }
}

class CategoryBreadcrumbs extends SliverPersistentHeaderDelegate {
  const CategoryBreadcrumbs();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text("지원목록",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Center(child: Text("전체보기")),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
