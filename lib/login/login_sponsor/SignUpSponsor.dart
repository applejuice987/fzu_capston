import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 광고주의 회원가입을 진행.

class SignUpSponsor extends StatefulWidget {
  const SignUpSponsor({Key? key}) : super(key: key);

  @override
  State<SignUpSponsor> createState() => _SignUpSponsorState();
}

class _SignUpSponsorState extends State<SignUpSponsor> {

  String loginValue = 'Sponsor';
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final companyNameController = TextEditingController();

  void signUpEmailAccount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (validatePasswordStructure(passwordController.text)) { //비밀번호 조건에 맞을 경우
        if (passwordController.text ==
            passwordCheckController.text) { //비밀번호와 비밀번호 확인이 일치할 경우

            final User? user = (await
            auth.createUserWithEmailAndPassword(
              email: idController.text,
              password: passwordController.text,)
            ).user;
            MySharedPreferences.instance.setBooleanValue("loggedin", true);
            MySharedPreferences.instance.setBooleanValue("isInflu", false);
            SignUpDatabaseHelper().backUpSponsorData(
                idController.text, passwordController.text,
                companyNameController.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
            const MyApp()));

        } else { //비밀번호와 비밀번호 확인이 일치하지 않을 경우
          //flutterToast('입력하신 비밀번호가 일치하지 않습니다.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("입력하신 비밀번호가 일치하지 않습니다.")));
        }
      } else { //비밀번호 조건에 맞지 않을 경우
        //flutterToast('비밀번호는 8자리 이상의 영문, 숫자, 특수문자가 포함되어야 합니다.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("비밀번호는 8자리 이상의 영문, 숫자, 특수문자가 포함되어야 합니다.")));
      }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이미 사용중인 이메일입니다.")));
    } else if (e.code == 'invalid-email') {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이메일 형식이 잘못되었습니다.")));
    } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("오류가 발생했습니다.")));
    }
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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$loginValue 회원가입", textAlign: TextAlign.left, style: TextStyle(fontSize: 40),),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Email'),
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.55,
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
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: passwordController,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Password 확인'),
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.55,
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
                  Text('기관명'),
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.55,
                    child: TextField(decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelStyle: TextStyle(color: Colors.black)),
                      controller: companyNameController,),
                  )
                ],
              ),

              ElevatedButton(onPressed: () {signUpEmailAccount();}, child: Text('회원가입'))

            ],
          )),
    );
  }
}
