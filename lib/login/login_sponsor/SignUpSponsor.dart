import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final User? user = (await
        auth.createUserWithEmailAndPassword(
          email: idController.text,
          password: passwordController.text,)
    ).user;
    SignUpDatabaseHelper().backUpSponsorData(
        idController.text, passwordController.text, companyNameController.text);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
    const MyApp()));
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
