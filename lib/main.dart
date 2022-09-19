import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fzu/Page_1/Page1Influencer.dart';
import 'package:fzu/Page_1/Page1Sponsor.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:fzu/Page_2/Page2Sponsor.dart';
import 'package:fzu/Page_3/Page3.dart';
import 'package:fzu/Page_4/Page4.dart';
import 'package:fzu/firebase_options.dart';
import 'package:fzu/login/MainLoginScreen.dart';

bool isInflu = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? FirebaseUser = FirebaseAuth.instance.currentUser;
    Widget firstwidget;
    var useremail = FirebaseAuth.instance.currentUser?.email.toString();
    var asdf;

    print("첫 빌드");
    try {
      FirebaseFirestore.instance
          .collection("user_influencer")
          .doc(useremail)
          .get()
          .then((DocumentSnapshot ds) {
        asdf = ds["email"].toString();
        print("1- this is $asdf");
      }).then((value) {
        if (asdf == useremail) {
          isInflu = true;
          print("1- isinflu true");
        }
      });
    } catch (e) {
      isInflu = false;
      print("1- isinflu false");
    }

    if (FirebaseUser != null) {
      firstwidget = const MyHomePage();
    } else {
      firstwidget = const MainLoginScreen();
    }

    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: firstwidget,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  var asdf;

  //bool isInflu = false;
  var useremail = FirebaseAuth.instance.currentUser?.email.toString();

  Widget build(BuildContext context) {
    //인플루언서 로그인시 실행되야하는 바텀 아이템
    List<Widget> influ_bottom = <Widget>[
      Page1Influencer(),
      Page2Influencer(),
      Page3(),
      Page4()
    ];
    //스폰서 로그인시 ~~
    List<Widget> spon_bottom = <Widget>[
      Page1Sponsor(),
      Page2Sponsor(),
      Page3(),
      Page4()
    ];
    print("2- ${isInflu.toString()}");

    return Scaffold(
      appBar: AppBar(
        title: Text("FZU"),
      ),
      body: isInflu ? influ_bottom[pageIndex] : spon_bottom[pageIndex],
      //isInflu가 true이면 왼쪽, 아니면 오른쪽

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyanAccent,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "First"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Second"),
          BottomNavigationBarItem(icon: Icon(Icons.android), label: "Third"),
          BottomNavigationBarItem(icon: Icon(Icons.apple), label: "Fourth"),
        ],
      ),
    );
  }
}
