import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Influencer2 extends StatefulWidget {
  final String applicant;

  const Page2Influencer2({Key? key, required this.applicant}) : super(key: key);

  @override
  State<Page2Influencer2> createState() => _Page2Influencer2State();
}

class _Page2Influencer2State extends State<Page2Influencer2> {
  final _nameController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();

  //final applicant = ModalRoute.of(context)!.settings.arguments as applicant;

  String _title = '';
  String _content = '';
  String _email = '';
  String _image = '';
  dynamic _applicant = [];
  CollectionReference adtable =
      FirebaseFirestore.instance.collection('AdTable');
  CollectionReference user =
      FirebaseFirestore.instance.collection('userInfoTable');

  @override
  void initState() {
    super.initState();
    print(widget.applicant);
    adtable.doc(widget.applicant).get().then((DocumentSnapshot ds) {
      setState(() {
        _title = ds['title'];
        _content = ds['content'];
        _email = ds['email'];
        _image = ds['image'];
        _applicant = ds['applicant'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            _title,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5,
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Image.memory(Base64Decoder().convert(_image)),
                Text(_title),
                Text(_content),
                Text(_email),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              //height: submitButtonHeigh,
              child: ElevatedButton(
                onPressed: () {
                  if (_applicant.contains(auth.currentUser!.email.toString())) {
                    Fluttertoast.showToast(msg: "이미 지원하신 광고입니다.");
                  } else {
                    adtable.doc(widget.applicant).update({
                      'applicant': FieldValue.arrayUnion([docId])
                    });
                    Fluttertoast.showToast(msg: "지원이 완료되었습니다.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1,
                ),
                child: Text("지원하기"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
