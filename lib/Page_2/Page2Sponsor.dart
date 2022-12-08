//import 'dart:html';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_2/Page2Sponsor_DetailAd.dart';
import 'package:fzu/Page_2/Page2Sponsor_AddAd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor extends StatefulWidget {
  const Page2Sponsor({
    Key? key,
    // required this.list
  }) : super(key: key);

  // final List<String> list;
  @override
  State<Page2Sponsor> createState() => _Page2SponsorState();
}

class _Page2SponsorState extends State<Page2Sponsor> {
  late final DocumentSnapshot documentData;
  List<String> _titleList = [];

  //_Page2SponsorState(this.documentData);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');

  FirebaseAuth auth = FirebaseAuth.instance;

  // getData() async {
  // var result = await firestore.collection("sponsor").doc("docId").get().then((value){
  // for(var doc in ){
  // String title = doc["title"];
  // String content = doc["content"];
  //
  // }
  //  });
  // return result;
  // }

  void initState() {
    var useremail = FirebaseAuth.instance.currentUser?.email.toString();
    FirebaseFirestore.instance
        .collection("AdTable")
    // .doc(useremail)
    // .collection('recruit')
        .where("email", isEqualTo: useremail)
        .get()
        .then((value) {
      setState(() {
        _titleList.clear();
        for (var doc in value.docs) {
          String title = doc["title"];
          String content = doc["content"];
          _titleList.add(doc['title'].toString());
        }
      });
      // MySharedPreferences.instance.setStringList('albamon', _titleList);
    });
    print("initState work in page2Sponsor");
    super.initState();
  }

  // refreshlist() {
  //   var useremail = FirebaseAuth.instance.currentUser?.email.toString();
  //   FirebaseFirestore.instance
  //       .collection("AdTable")
  //       // .doc(useremail)
  //       // .collection('recruit')
  //       .where("email", isEqualTo: useremail)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       _titleList.clear();
  //       for (var doc in value.docs) {
  //         String title = doc["title"];
  //         String content = doc["content"];
  //         _titleList.add(doc['title'].toString());
  //       }
  //     });
  //     // MySharedPreferences.instance.setStringList('albamon', _titleList);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // refreshlist();
    // var _titleList = MySharedPreferences.instance.getStringList('albamon');
    //  List<String> _titleList = widget.list;
    return Scaffold(
      body: Container(
        child: ListView.separated(
          itemCount: _titleList.isEmpty ? 1 : _titleList.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                height: 20,
                  child: _titleList.isEmpty
                      ? const Text(
                          "새로운 공고를 추가해보세요",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          _titleList[index],
                          style: const TextStyle(color: Colors.black),
                        ),

              ),
              onTap : () {
                _titleList.isEmpty ? print("nothing") :
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Page2Sponsor_DetailAd(title : _titleList[index].toString())));
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text(_titleList[index])));
              },);
          },
          separatorBuilder: (context, index){
            return Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: const Divider(
                thickness: 1,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Page2Sponsor_AddAd()));
        },
        backgroundColor: const Color(0xffc9b9ec),
        child: const Text(
          "+",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
