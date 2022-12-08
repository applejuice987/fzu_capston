import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Sponsor_DetailAd.dart';
import 'package:fzu/Page_2/Page2Sponsor_AddAd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor extends StatefulWidget {
  const Page2Sponsor({
    Key? key,
  }) : super(key: key);

  @override
  State<Page2Sponsor> createState() => _Page2SponsorState();
}

class _Page2SponsorState extends State<Page2Sponsor> {
  late final DocumentSnapshot documentData;
  List<String> _titleList = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    var useremail = FirebaseAuth.instance.currentUser?.email.toString();
    FirebaseFirestore.instance
        .collection("AdTable")
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
    });
    print("initState work in page2Sponsor");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("공고 목록"),
        backgroundColor: Colors.white24,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: _titleList.isEmpty ? 1 : _titleList.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
            },);
        },
        separatorBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const Divider(
              thickness: 1,
              color: Colors.black,
            ),
          );
        },
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
