import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';


class detailPage_Influencer extends StatefulWidget {
  final String email;
  const detailPage_Influencer({Key? key, required this.email}) : super(key: key);

  @override
  State<detailPage_Influencer> createState() => _detailPage_InfluencerState();
}

class _detailPage_InfluencerState extends State<detailPage_Influencer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('상세정보', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
      ),
    );
  }
}
