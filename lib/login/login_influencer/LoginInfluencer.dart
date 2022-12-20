import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/login/FindAccount.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/login/login_influencer/SignUpInfluencer.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 인플루언서 로그인과 회원가입을 실행할 수 있음.

class LoginInfluencer extends StatefulWidget {
  const LoginInfluencer({Key? key}) : super(key: key);

  @override
  State<LoginInfluencer> createState() => _LoginInfluencerState();
}

class _LoginInfluencerState extends State<LoginInfluencer> {
  final in_email_controller = TextEditingController();
  final in_pw_controller = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  var q = "user_influencer";
  bool _passwordObscure = true;

  @override
  void initState() {
    super.initState();

    _passwordObscure = true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          color: const Color(0xffc9b9ec),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              Column(
                children: [
                  const Text("인플루언서님 안녕하세요!", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Container(
                    height: 3,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Column(
                  children: <Widget> [
                    TextField(
                      controller: in_email_controller,
                      decoration: buildInputDecoration("이메일", true)
                    ),
                    TextField(
                      controller: in_pw_controller,
                      obscureText: _passwordObscure,
                      decoration: buildInputDecoration("비밀번호",false),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(onPressed: () {
                        String email = in_email_controller.text.replaceAll(' ', '');
                        SignUpDatabaseHelper().loginFunc(email, in_pw_controller.text, context, true);
                      }, style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 15,
                            shadowColor: Colors.black,
                            side: const BorderSide(color: Colors.black, width : 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                        ), child: const Text("로그인",style: TextStyle(color: Colors.black),),),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 30,
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpInfluencer()));
                            }, child: const Text("회원가입",style: TextStyle(color: Colors.black),)),
                          ),
                          SizedBox(height: 30,
                            child: TextButton(onPressed: (){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()),(Route<dynamic> route) => false);
                            }, child: const Text("메인으로 넘어가기", style: TextStyle(color: Colors.black),)),
                          ),
                          SizedBox(height: 30,
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FindAccount()));
                            }, child: const Text("비밀번호를 잊으셨나요?", style: TextStyle(color: Colors.black),)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }


  InputDecoration buildInputDecoration(String asdf, bool istrue) {
    if (istrue == false) {
      return InputDecoration(
          labelText: asdf,
          focusColor: Colors.black,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          labelStyle: TextStyle(color: Colors.black),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordObscure = !_passwordObscure;
                });
              },
              icon: Icon(
                _passwordObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,))
      );
    } else {
      return InputDecoration(
          labelText: asdf,
          focusColor: Colors.black,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          labelStyle: TextStyle(color: Colors.black)
      );
    }
  }
}
