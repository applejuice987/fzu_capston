//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_2/Page2Sponsor2.dart';
import 'package:fzu/Page_2/Page2Sponsor3.dart';
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
  // getData() async  {
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
          _titleList.add(doc['title'].toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    refreshlist();
   // var _titleList = MySharedPreferences.instance.getStringList('albamon');
   //  List<String> _titleList = widget.list;
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(30),
      //   child: AppBar(
      //     backgroundColor: Color(0xffC9B9EC),
      //     title: Text("광고확인"),
      //   ),
      // ),
      body: Container(
        color: Color(0xffd6cdea),
        child:
        ListView.builder(itemCount: _titleList.length,
        itemBuilder: (ctx, index){
          return Container(
            margin: const EdgeInsets.fromLTRB(15, 2.5, 15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Page2Sponsor2()));
              },
              child: Card(
              child: SizedBox(
                height: 50
                  ,child: _tile(_titleList[index],''))
              ),
            ),
          );
        },),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Page2Sponsor3()));},
        child: const Icon(Icons.add),
      ),
    );
  }
  ListTile _tile(String title, String subTitle) => ListTile(
    title: Text(
      title,
      style: const TextStyle(fontSize: 20,),
    ),
    subtitle: Text(subTitle),
  );
}