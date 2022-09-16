import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/login/login_influencer/LoginInfluencer.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

void main() {
  runApp(const MyApp2());
}
//TODO!! 기본 로그인 화면, 이 화면에서 인플루언서 로그인 화면과 광고주 로그인 화면으로 옮겨짐.

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: Colors.cyanAccent,
          backgroundColor: Colors.cyanAccent
      ),
      home: const MainLoginScreen(),
    );
  }
}



class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({Key? key}) : super(key: key);

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyanAccent,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget> [
            const Text("프주에 오신것을 환영합니다! \n 아래를 통해 로그인하시길 바랍니다."),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginInfluencer()));
                  }, child: const Text("인플루언서 로그인")),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    const LoginSponsor()));
                  } , child: const Text("광고주 로그인")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}








