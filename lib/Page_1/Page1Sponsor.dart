import 'dart:convert';
import 'dart:developer';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fzu/Page_1/influItem.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fzu/main.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';



//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();
}


class _Page1SponsorState extends State<Page1Sponsor> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController _controller=PageController();
  var email = "??";
  var platform = "??";
  @override
  Widget build(BuildContext context) {

    String email = '??';
    String platform = '??';



    return  MaterialApp(

        home: Scaffold(
          resizeToAvoidBottomInset: false,
          //backgroundColor: Colors.c700],
          body: SafeArea(
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 35),
                alignment: AlignmentDirectional.center,
                child: Text('광고모델 모집하기',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4),
              ),
              GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                },


              child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance.collection('user_influencer').snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text('Loading');
                }

                final docs = snapshot.data!.docs;
                return
                    SizedBox(
                      height: 500,
                      child:
                    PageView.builder(

                      controller: _controller,
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,

                        physics: ScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index){
                    return Container(
                        child: Column(children: <Widget>[


                          Container(

                        child: Image.memory(Base64Decoder().convert(docs[index]['profile']))
                        //Base64Decoder().convert(docs['profile'])

                            ),




                        Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(docs[index]['email'],
                          style: TextStyle(fontSize: 20.0),
                        ),
                        ),
                           Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(docs[index]['platform'],
                          style: TextStyle(fontSize: 20.0),
                        )



                    ),
                         ],
                    ),


                    );




                  }
                ),

                ); /*itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(docs[index]['text'],
                          style: TextStyle(fontSize: 20.0),
                        )*/





              }
              ),
              )







/*
                Expanded(
                  child: PageView.builder(
                      controller: PageController(
                        initialPage: 0, //시작 페이지
                      ),
                      itemCount: ,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(children: [



                            Flexible(
                              flex: 3,
                              child: Container(
                                height: 200,
                                child: Image.asset(
                                  InfluList!.list!.elementAt(index).image!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(email),
                            Flexible(
                              flex: 2,
                              child:ListView.builder(
                                shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (ctx, index) => Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                      SpecialOfferCard(
                                      image: "aaa",
                                      category: snapshot.data?.docs[index]['name'],
                                      numOfBrands: snapshot.data?.docs[index]['maxcost'],
                                      press: () {},
                                  )
                                    ]
                              ),
                            ),




                          ),


                        )]),);
                      }

                  )
                  ,
                );
            */




            ],

            ),

          ),
          bottomNavigationBar: SafeArea(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .subtitle1),
                child: Text('매칭하기'),
              )),
        )
    );
  }
}

