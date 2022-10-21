import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();
}

class _Page1SponsorState extends State<Page1Sponsor>
    with SingleTickerProviderStateMixin {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController _controller = PageController();

  static final List<Category> _Cates = [
    Category(id: 1, name: "Car"),
    Category(id: 2, name: "Song"),
    Category(id: 3, name: "Passion"),
    Category(id: 5, name: "Travel"),
    Category(id: 6, name: "Dance"),
    Category(id: 7, name: "Art"),
    Category(id: 8, name: "Art"),
    Category(id: 9, name: "Art"),
    Category(id: 10, name: "Art"),
    Category(id: 11, name: "Art"),
    Category(id: 12, name: "Art"),
    Category(id: 13, name: "Art"),
    Category(id: 14, name: "Art"),
    Category(id: 15, name: "Art"),
    Category(id: 16, name: "Art"),
    Category(id: 17, name: "Art"),
    Category(id: 18, name: "Art"),
    Category(id: 19, name: "Art"),
    Category(id: 20, name: "Art"),
    Category(id: 21, name: "Art"),
    Category(id: 22, name: "Art"),
    Category(id: 23, name: "Art"),
    Category(id: 24, name: "Art"),
    Category(id: 25, name: "Art"),
    Category(id: 26, name: "Art"),
    Category(id: 27, name: "Art"),
  ];
  final _items =
  _Cates.map((Cates) => MultiSelectItem<Category>(Cates, Cates.name))
      .toList();

  void _incrementCounter() {
    setState(() {});
  }

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 6);
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffC9B9EC),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                alignment: AlignmentDirectional.center,
                child: Text('광고모델 모집하기',
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),

              //################################################################################################
              // Rounded blue MultiSelectDialogField
              //################################################################################################
              Container(
                width: 350,
                height: 100,
                child: MultiSelectDialogField(
                  items: _items,
                  title: Text("Category"
                    ,style: TextStyle(
                      color: Colors.purple[800])
                  ),
                  selectedColor: Colors.purple[800],
                  decoration: BoxDecoration(
                    color: Color(0xffC9B9EC),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.add_card,
                    color: Colors.black,
                  ),
                  buttonText: Text(
                    "Category",
                    style: TextStyle(
                      color: Colors.purple[800],
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (results) {
                    //_selectedAnimals = results;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection('user_influencer')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }

                      final docs = snapshot.data!.docs;
                      return SizedBox(
                        height: 800,
                        child: PageView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            pageSnapping: true,
                            physics: ScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        padding:
                                        EdgeInsets.fromLTRB(50, 0, 50, 15),
                                        child: Container(
                                            child: Image.memory(Base64Decoder()
                                                .convert(
                                                docs[index]['profile']))
                                          //Base64Decoder().convert(docs['profile'])
                                        )),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding:
                                        EdgeInsets.fromLTRB(30, 5, 30, 5),
                                        child: Text(
                                          docs[index]['email'],
                                          style: TextStyle( color: Colors.purple,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding:
                                          EdgeInsets.fromLTRB(30, 5, 30, 5),
                                          child: Text(
                                            docs[index]['platform'],
                                            style: TextStyle( color: Colors.purple,
                                                fontSize: 15.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding:
                                          EdgeInsets.fromLTRB(30, 5, 30, 5),
                                          child: Text(
                                            docs[index]['Subscribers'],
                                            style: TextStyle( color: Colors.purple,
                                                fontSize: 15.0),
                                          )),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          padding:
                                          EdgeInsets.fromLTRB(30, 5, 30, 5),
                                          child: Text(
                                            docs[index]['Category'],
                                            style: TextStyle( color: Colors.purple,
                                                fontSize: 15.0),
                                          )),
                                    ),

                                    ElevatedButton(
                                        onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          elevation: 15,
                                          shadowColor: Colors.black,
                                          side: const BorderSide(color: Colors.black, width : 1.5),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                        child: const Text(
                                        '매칭하기',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),)

                                  ],
                                ),
                              );
                            }),
                      );
                    }),
              )
            ],
          ),
        ),

      ),
    );
  }

  ButtonStyle basicbuildStyleFrom() {
    return ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 15,
        shadowColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
    );
  }
}
