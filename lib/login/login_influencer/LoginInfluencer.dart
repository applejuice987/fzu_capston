import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/login/FindAccount.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
          alignment: Alignment.center,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              const Text("인플루언서님 안녕하세요!",style: TextStyle(fontSize: 25),),
              Column(
                children: <Widget> [
                  TextField(
                    controller: in_email_controller,
                    decoration: const InputDecoration(
                      labelText: "이메일",
                    ),
                  ),
                  TextField(
                    controller: in_pw_controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "비밀번호",
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(onPressed: () {
                      //TODO!! 파이어베이스 연동하고 로그인 넣어야함.;
                    }, child: const Text("로그인")),
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
                          }, child: const Text("회원가입")),
                        ),
                        SizedBox(height: 30,
                          child: TextButton(onPressed: (){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()),(Route<dynamic> route) => false);
                          }, child: const Text("메인으로 넘어가기")),
                        ),
                        SizedBox(height: 30,
                          child: TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FindAccount()));
                          }, child: const Text("비밀번호를 잊으셨나요?")),
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
