import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 인플루언서 회원가입을 진행.

class SignUpInfluencer extends StatefulWidget {
  const SignUpInfluencer({Key? key}) : super(key: key);

  @override
  State<SignUpInfluencer> createState() => _SignUpInfluencerState();


}

class _SignUpInfluencerState extends State<SignUpInfluencer> {


  String loginValue = 'Influencer';
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final platformNameController = TextEditingController();

  void signUpEmailAccount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (validateEmailStructure(idController.text)) {
      if (validatePasswordStructure(passwordController.text)) { //비밀번호 조건에 맞을 경우
        if (passwordController.text ==
            passwordCheckController.text) { //비밀번호와 비밀번호 확인이 일치할 경우
          final User? user = (await
          auth.createUserWithEmailAndPassword(
            email: idController.text,
            password: passwordController.text,)
          ).user;
          MySharedPreferences.instance.setBooleanValue("loggedin", true);
          MySharedPreferences.instance.setBooleanValue("isInflu", true);
          SignUpDatabaseHelper().backUpSponsorData(
              idController.text, passwordController.text,
              platformNameController.text);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
          const MyApp()));
        } else { //비밀번호와 비밀번호 확인이 일치하지 않을 경우
          flutterToast('입력하신 비밀번호가 일치하지 않습니다.');
        }
      } else { //비밀번호 조건에 맞지 않을 경우
        flutterToast('비밀번호는 8자리 이상의 영문, 숫자, 특수문자가 포함되어야 합니다.');
      }
    } else {
      flutterToast('이메일 형식에 맞게 작성해주세요.');
    }
  }

  void flutterToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  bool validatePasswordStructure(String value) { //비밀번호 조건 확인 함수
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  bool validateEmailStructure(String value) { //이메일 조건 확인 함수
    String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
          width: size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$loginValue 회원가입", textAlign: TextAlign.left, style: TextStyle(fontSize: 35),),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Email'),
                  SizedBox(width: size.width*0.05,),
                  Container(
                    width: size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: idController,),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Password'),
                  SizedBox(width: size.width*0.05,),
                  Container(
                    width: size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: passwordController,),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Password 확인'),
                  SizedBox(width: size.width*0.05,),
                  Container(
                    width: size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: passwordCheckController,),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('활동 플랫폼'),
                  SizedBox(width: size.width*0.05,),
                  Container(
                    width: size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: platformNameController,),
                  )
                ],
              ),

              ElevatedButton(onPressed: () {signUpEmailAccount();}, child: Text('회원가입'))

            ],
          )),
    );
  }
}