import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:fzu/Page_2/Page2Influencer_DetailAd.dart';

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

  bool _isNeedy = false;
  Color dateColor = Colors.black;
  Map<String, List<String>> adMap = {};
  var db = FirebaseFirestore.instance;
  

  @override
  void initState() {
    super.initState();
    db.collection("AdTable").orderBy('duration').get().then((value) {
      setState(() {
        for (var doc in value.docs) {
          List<String> adValue = [];
          String title = doc["title"];
          String duration = doc["duration"];
          String email = doc['email'];
          adValue.add(doc['duration']);
          db.collection('userInfoTable').doc('user').collection('user_sponsor').doc(email).get().then((DocumentSnapshot ds) {
            setState(() {
              adValue.add(ds['profile']);
            });


          });
          adMap.putIfAbsent(title, () => adValue);
        }
      });
      // MySharedPreferences.instance.setStringList('albamon', _titleList);
    });
    refreshlist();
  }

  refreshlist() {

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
    //refreshlist();

    String deadLine(String duration) {
      List<String> data = duration.split(" ");
      DateTime endDate = DateFormat("yyyy-MM-dd").parse(data[2]);
      int difference =
      int.parse(endDate.difference(DateTime.now()).inDays.toString());
      if (difference <= 7 && difference >= 0) {
          _isNeedy = true;
          dateColor = Colors.red;
        return '마감 $difference일 전!';
      } else if (difference > 7) {
        _isNeedy = false;
        dateColor = Colors.black;
          return '~ ${data[2]}';
      } else if (endDate.isBefore(DateTime.now())){
        dateColor = Colors.grey;
        _isNeedy = false;
        return '마감';
      } else {
        return '';
      }
    }

    return Scaffold(
        body: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / 1.1),
      children: List.generate(adMap.length, (index) {
        return Container(
          child: InkWell(
            onTap: () {
              String applicant = adMap.keys.elementAt(index);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Page2Influencer2(applicant: applicant)));
            },
            child: Container(
              height: 1000,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    child: Image.memory(Base64Decoder().convert(adMap.values.elementAt(index)[1])),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(adMap.keys.elementAt(index)),
                  Text(
                    deadLine(adMap.values.elementAt(index)[0]),
                    style:
                        //TextStyle(color: _isNeedy ? Colors.red : Colors.black),
                    TextStyle(color: dateColor),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ));
  }
}
