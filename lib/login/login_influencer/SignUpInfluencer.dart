import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    final User? user = (await
    auth.createUserWithEmailAndPassword(
      email: idController.text,
      password: passwordController.text,)
    ).user;
    SignUpDatabaseHelper().backUpInfluencerData(
        idController.text, passwordController.text, platformNameController.text);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    const MyApp()));
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