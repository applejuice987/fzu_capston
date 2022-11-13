import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Influencer2.dart';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

class Page2Influencer extends StatefulWidget {
  const Page2Influencer({Key? key}) : super(key: key);

  @override
  State<Page2Influencer> createState() => _Page2InfluencerState();
}



class _Page2InfluencerState extends State<Page2Influencer> {

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // CollectionReference sponsor = FirebaseFirestore.instance.collection('sponsor');

  FirebaseAuth auth = FirebaseAuth.instance;
  late String docId = auth.currentUser!.email.toString();


  List<String> _adList = [];
  Map<String, dynamic> Middle_Datainfo = Map<String, dynamic>();

  void initState() {
    super.initState();
  }
  refreshlist(){
    FirebaseFirestore.instance.collection("sponsor").doc('fullad').collection('recruit').get().then((value) {
      setState(() {
        _adList.clear();
        for (var doc in value.docs) {
          String title = doc["title"];
          String content = doc["content"];
          _adList.add(doc['title'].toString());
        }
      });
      // MySharedPreferences.instance.setStringList('albamon', _titleList);
    });
  }

  // refreshlist() {
  //   FirebaseFirestore.instance.collection("sponsor").get().then((value) {
  //     setState(() {
  //       _adList.clear();
  //       for (var doc in value.docs) {
  //         _adList.add(doc['adList'].toString());
  //       }
  //     });
  //   });
  // }
  // getdata(){
  //   FirebaseFirestore.instance.collection("sponsor").get().then((value) => _SnapshotResulMiddle = value.docs);
  //
  //   for (int i = 0; i< _SnapshotResulMiddle.length; i++){
  //     Middle_Datainfo = _SnapshotResulMiddle[i].data() as Map<String, dynamic>;
  //
  //     _adList.addAll(List.from(Middle_Datainfo['adList']));
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection("sponsor").get().then((value) {
    //   setState(() {
    //     _adList.clear();
    //     for (var doc in value.docs) {
    //       _adList.add(doc['adList'].toString());
    //     }
    //   });
    // });
     refreshlist();


    return Scaffold(
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1/1.5),
          children: List.generate(_adList.length, (index) {
            return Container(
              child: InkWell(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Page2Influencer2()));
                },
              child: Container(
                height: 1000,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    CircleAvatar(radius: 70,),
                    SizedBox(height: 20,),
                    Text(_adList[index]),
                    Text('회사명'),
                ],
                ),
            ),
              ),
            );
          }

          ),
        )
    );
  }
}

