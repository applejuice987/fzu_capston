import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fzu/firebase_options.dart';
import 'package:fzu/login/login_influencer/LoginInfluencer.dart';
import 'package:fzu/login/login_sponsor/LoginSponsor.dart';

import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp2());
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? FirebaseUser = FirebaseAuth.instance.currentUser;
    Widget firstwidget;

    if (FirebaseUser != null) {
      firstwidget = const MyApp();
    } else {
      firstwidget = const MainLoginScreen();
    }

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
          scaffoldBackgroundColor: Color(0xFFc9b9ec),
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xffc9b9ec),
          backgroundColor: const Color(0xffc9b9ec)),
      home: firstwidget,
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
        color: const Color(0xffc9b9ec),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("프주에 오신것을 환영합니다!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "아래를 눌러 로그인하시길 바랍니다.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                ),
              ],
            ),
            Container(
                height: 300,
                child: Image.asset("assets/images/flower.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginInfluencer()));
                    },
                    style: basicbuildStyleFrom(),
                    child: buildloginText("인플루언서 로그인"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginSponsor()));
                      },
                    style: basicbuildStyleFrom(),
                      child: buildloginText("광고주 로그인"),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Text buildloginText(String asdf) {
    return Text(
      asdf,
      style: const TextStyle(color: Colors.black,),
    );
  }

  ButtonStyle basicbuildStyleFrom() {
    return ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 15,
                    shadowColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width : 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                  );
  }
}
