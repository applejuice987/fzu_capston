//import 'dart:html';
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
  const Page2Sponsor({Key? key,
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
    super.initState();
  }
  refreshlist(){
    var useremail = FirebaseAuth.instance.currentUser?.email.toString();
    FirebaseFirestore.instance.collection("sponsor").doc(useremail).collection('recruit').get().then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    refreshlist();
   // var _titleList = MySharedPreferences.instance.getStringList('albamon');
   //  List<String> _titleList = widget.list;
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            //const SliverAppBar(
            //title: Text("새로운 광고모집을 추가하세요"),
            //floating: true,
            //flexibleSpace: Placeholder(),
            // expandedHeight: 100,
            // ),
            SliverToBoxAdapter(

                child: Container(
                  padding: const EdgeInsets.all(30),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Page2Sponsor_AddAd()));
                      }, child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: const Icon(
                          CupertinoIcons.plus,
                        ),),),
                      //CircleAvatar(
                      //radius: 30,
                      // backgroundColor: Colors.black,
                      // child: const Icon(
                      // CupertinoIcons.plus,
                      // ),),
                      Text("새로운 광고 모집하기"),

                    ],
                  ),
                )
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _titleList.isEmpty ? Text("아무것도 없음") : ListTile(title:Text(_titleList[index]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Page2Sponsor_DetailAd()));
                  },),
                childCount: _titleList.length,
              ),
            ),
            // StreamBuilder<QuerySnapshot>(
          ],
        ),
      ),
    );
  }
}