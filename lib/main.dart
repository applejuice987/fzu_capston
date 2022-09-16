import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_1/Page1Influencer.dart';
import 'package:fzu/Page_1/Page1Sponsor.dart';
import 'package:fzu/Page_2/Page2Influencer.dart';
import 'package:fzu/Page_2/Page2Sponsor.dart';
import 'package:fzu/Page_3/Page3.dart';
import 'package:fzu/Page_4/Page4.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  List<Widget> pageList = <Widget>[
    //Page1Influencer(),
    Page1Sponsor(),
    Page2Influencer(),
    //Page2Sponsor(),
    Page3(),
    Page4()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pageList[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyanAccent,
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [BottomNavigationBarItem(icon: Icon(Icons.add),label: "First"),
          BottomNavigationBarItem(icon: Icon(Icons.delete),label: "Second"),
          BottomNavigationBarItem(icon: Icon(Icons.android),label: "Third"),
          BottomNavigationBarItem(icon: Icon(Icons.apple),label: "Fourth"),
        ],
      ),
    );
  }
}
