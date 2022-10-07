import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/login/FindAccount.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/login/login_sponsor/SignUpSponsor.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 광고주 로그인과 회원가입을 실행할 수 있음.

class LoginSponsor extends StatefulWidget {
  const LoginSponsor({Key? key}) : super(key: key);

  @override
  State<LoginSponsor> createState() => _LoginSponsorState();
}

class _LoginSponsorState extends State<LoginSponsor> {
  final sp_email_controller = TextEditingController();
  final sp_pw_controller = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  var q = "user_sponsor";
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
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
          alignment: Alignment.center,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                "광고주님 안녕하세요!",
                style: TextStyle(fontSize: 25),
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: sp_email_controller,
                    decoration: const InputDecoration(
                      labelText: "이메일",
                    ),
                  ),
                  TextField(
                    controller: sp_pw_controller,
                    obscureText: _passwordObscure,
                    decoration: InputDecoration(
                      labelText: "비밀번호",
                        suffixIcon: IconButton(
                            onPressed: () {
                          setState(() {
                            _passwordObscure = !_passwordObscure;
                          });
                        },
                            icon: Icon(_passwordObscure ? Icons.visibility : Icons.visibility_off))
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          SignUpDatabaseHelper().loginFunc(sp_email_controller.text, sp_pw_controller.text, context, false);
                          },
                        child: const Text("로그인")),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpSponsor()));
                              },
                              child: const Text("회원가입")),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text("메인으로 넘어가기")),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FindAccount()));
                              },
                              child: const Text("비밀번호를 잊으셨나요?")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
