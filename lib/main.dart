import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/Page_1/Page1Influencer.dart';
import 'package:fzu/Page_1/Page1Sponsor.dart';
import 'package:fzu/Page_1/Create_Info.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:fzu/Page_2/Page2Influencer_DetailAd.dart';
import 'package:fzu/Page_2/Page2Sponsor.dart';
import 'package:fzu/Page_3/Page3.dart';
import 'package:fzu/Page_4/Page4.dart';
import 'package:fzu/firebase_options.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'Page_2/Page2Sponsor_DetailAd.dart';

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

  bool isInflu = false;
  bool isadmin = false;

  @override
  Widget build(BuildContext context) {
    User? FirebaseUser = FirebaseAuth.instance.currentUser;
    Widget firstwidget ;


    if (FirebaseUser != null) {
      firstwidget = const MyHomePage();
    } else {
      firstwidget = const MainLoginScreen();
    }

    return GestureDetector(
      onTap: (){
        FocusNode currentFocus = FocusScope.of(context);

        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        builder: (context,child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!),
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
      ),
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

  bool isInflu = false;
  bool isadmin = false;
  var useremail = FirebaseAuth.instance.currentUser?.email.toString();

  void initState() {
    MySharedPreferences.instance.getBooleanValue("isInflu").then((value) =>
        setState(() {
          print('3-1$isInflu');
          isInflu = value;
          print('3-2$isInflu');
        }));
    try {
      FirebaseFirestore.instance
          .collection("userInfoTable")
          .doc("admin")
          .collection("user_admin")
          .doc(useremail)
          .get()
          .then((value) {
        if (value.exists) {
          isadmin = true;
          print("1 isadmin value = ");
          print(isadmin);
        } else {
          isadmin = false;
          print("2 isadmin value = ");
          print(isadmin);
        }
      });
    } catch(e){
      print(e);
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    //인플루언서 로그인시 실행되야하는 바텀 아이템
    List<Widget> influ_bottom = <Widget>[
     Create_Info(),
     // Page1Influencer(),
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
        centerTitle: true,
        surfaceTintColor: const Color(0xffc9b9ec),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xffc9b9ec),
        title: const Text("FZU",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: const Color(0xffc9b9ec),
          child: isInflu ? influ_bottom[pageIndex] : spon_bottom[pageIndex]),
      //isInflu가 true이면 왼쪽, 아니면 오른쪽

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color:Colors.grey,
          border: Border(top: BorderSide(color: Colors.grey, width : 1.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black, blurRadius: 3)
          ]
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xffc9b9ec),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.add),label: "찾기"),
            BottomNavigationBarItem(icon: Icon(Icons.delete),label: "내 광고"),
            BottomNavigationBarItem(icon: Icon(Icons.android),label: "채팅"),
            BottomNavigationBarItem(icon: Icon(Icons.apple),label: "내 정보"),
          ],
        ),
      ),
    );
  }
}