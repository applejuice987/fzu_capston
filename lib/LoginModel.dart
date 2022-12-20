import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/main.dart';

class LoginModel {
  final String? email;

  LoginModel({
    required this.email
});

  final DocumentReference authDB = FirebaseFirestore.instance.collection('userInfoTable').doc('user');


  // static -> 빌드 시에 static 메모리에 다 담아 그래서 바로 꺼내올 수 있음
  // instance -> 빌드 시에 모름 -> instance를 생성해줘야됌 -> 생성한 후에 가져와야 댐


  void toJson() {
    bool isInflu = false;
    MySharedPreferences.instance.getBooleanValue("isInflu").then((value) {
        isInflu = value;
    });
    if (isInflu)
      toJson_Influencer();
    else
      toJson_Sponsor();
  }

  void setData() {
    print('setData in LoginModel');
    //print(toJson());
    /* MyApp.loginSession = */toJson();
  }

  void toJson_Sponsor() {
    Map<String, dynamic> userDB = {};
    authDB.collection('user_sponsor').doc(email).get().catchError((onError) {
      print('toJson_Sponsor Error');
      print(onError);
      Fluttertoast.showToast(msg: '회원 정보를 받아오는 데 실패했습니다.\n네트워크 환경 문제일 수 있으니 네트워크 연결을 확인해주세요.');
    }).then((DocumentSnapshot ds) {
      print('Insert userDB Sponser');
      userDB = {
        'email' : ds['email'],
        'adList' : ds['adList'],
        'blackList' : ds['blackList'],
        'ceoName' : ds['ceoName'],
        'company' : ds['company'],
        'likeInfList' : ds['likeInfList'],
        'profile' : ds['profile'],
        'type' : ds['type']
      };
      print('${ds['email']} in toJson_Sponsor');
    }).then((_) {
      MyApp.loginSession = userDB;
    });
    print('$userDB Sponsor');
    // return userDB;
  }

  Map<String, dynamic> toJson_Influencer() {
    Map<String, dynamic> userDB = {};
    authDB.collection('user_influencer').doc(email).get().catchError((onError) {
      print('toJson_Influencer Error');
      print(onError);
      Fluttertoast.showToast(msg: '회원 정보를 받아오는 데 실패했습니다.\n네트워크 환경 문제일 수 있으니 네트워크 연결을 확인해주세요.');
    }).then((DocumentSnapshot ds) {
      print('Insert userDB Influencer');
      userDB = {
        'email' : ds['email'],
        'PRAny' : ds['PRAny'],
        'PRImage' : ds['PRImage'],
        'PRText' : ds['PRText'],
        'blackList' : ds['blackList'],
        'category' : ds['category'],
        'channelName' : ds['channelName'],
        'likeSpoList' : ds['likeSpoList'],
        'profile' : ds['profile'],
        'contents' : ds['contents'],
        'displayName' : ds['displayName'],
        'filteringTextList' : ds['filteringTextList'],
        'isOnlyImage' : ds['isOnlyImage'],
        'type' : ds['type'],
        'likeAdList' : ds['likeAdList'],
        'platform' : ds['platform'],
        'subscribers' : ds['subscribers']
      };
    });
    print('${userDB}' + 'Influencer');
    return userDB;
  }

}