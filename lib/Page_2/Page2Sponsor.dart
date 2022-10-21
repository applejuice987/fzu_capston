//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Sponsor2.dart';
import 'package:fzu/Page_2/Page2Sponsor3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor extends StatefulWidget {
  const Page2Sponsor({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor> createState() => _Page2SponsorState();
}
void getdata1() {
var db = FirebaseFirestore.instance;
 db.collection("sponsor").get().then((value) {
 for (var doc in value.docs) {
  String title = doc["title"];
  String content = doc["content"];
 }
 });
 }

class _Page2SponsorState extends State<Page2Sponsor> {
  late final DocumentSnapshot documentData;

  //_Page2SponsorState(this.documentData);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');

  FirebaseAuth auth = FirebaseAuth.instance;
  late String docId = auth.currentUser!.email.toString();
  //CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');

  Stream collectionStream = FirebaseFirestore.instance.collection('sponsor').snapshots();
  Stream documentStream = FirebaseFirestore.instance.collection('sponsor').doc('docId').collection('recruit').snapshots();
  //var documentSnapshot = sponsor.doc('docId').get();

  //getData() async {
    //var result = await firestore.collection("sponsor").doc("docId").get().then((value){
      //for(var doc in ){
       // String title = doc["title"];
       // String content = doc["content"];

     // }
  //  });
    //return result;
 // }


  String _currentUser = '';
  List<String> _titleList = [];

  void initState() {
    super.initState();
    var db = FirebaseFirestore.instance;

    _currentUser = FirebaseAuth.instance.currentUser!.email.toString();
    db.collection("sponsor").doc('dhgns3926@daum.net').collection('recruit').get().then((value) {
      for (var doc in value.docs) {
        String title = doc["title"];
        String content = doc["content"];
        _titleList.add(doc['title'].toString());
      }
    });
  }


  @override
  Widget build(BuildContext context) {
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
                                builder: (context) => const Page2Sponsor3()));
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
              (context, index) => ListTile(title:Text(_titleList[index]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Page2Sponsor2()));
                      },),
                childCount: 10,
              ),
            ),
           // StreamBuilder<QuerySnapshot>(
             // stream: firestore.collection('sponsor').snapshots(),

             // builder: (context, snapshot) {
              //  if (snapshot.connectionState == ConnectionState.waiting){
               //   return CircularProgressIndicator();
              //  }
              //  return ListView.builder(
               //   itemCount: snapshot.data!.documents.length,
                //  itemBuilder: (ctx, index) => Container(
                //    padding: EdgeInsets.all(8),
                //    child: Text(snapshot.data.documents[index]['text']),
               //   ),
              //  );
            //  }
          //  ),
          ],
        ),
      ),
    );
  }
}







