import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:fzu/detailPage_Influencer.dart';

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page1Sponsor extends StatefulWidget {
  const Page1Sponsor({Key? key}) : super(key: key);

  @override
  State<Page1Sponsor> createState() => _Page1SponsorState();
}

class _Page1SponsorState extends State<Page1Sponsor> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController _controller = PageController();

  String _email = '';

  // multiple choice default value
  List<String> tags = [];

  // list of string options
  List<String> options = [
    '뷰티',
    '음식',
    '게임',
    '모바일게임',
    '자동차',
    '옷',
    '공부',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];

  String? user;

  @override
  Widget build(BuildContext context) {
    double marginmin = MediaQuery.of(context).size.width * 0.03;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffC9B9EC),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Flexible(
                fit: FlexFit.loose,
                child: ChipsChoice<String>.multiple(
                  value: tags,
                  onChanged: (val) => setState(() {
                    tags = val;
                    print(tags);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: options,
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  choiceCheckmark: true,
                  choiceStyle: C2ChipStyle.outlined(
                      checkmarkColor: Colors.white,
                      color: Colors.white,
                      foregroundStyle: const TextStyle(color: Colors.black)),
                ),
              ),
            ),

            ///여기까지 상단의 multiple choice
            ///
            Container(
              margin: const EdgeInsets.only(top: 35),
              alignment: AlignmentDirectional.center,
              child: const Text('광고모델 모집하기',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
            ),
            StreamBuilder<dynamic>(
                stream: tags.isEmpty
                    ? FirebaseFirestore.instance
                        .collection('userInfoTable')
                        .doc('user')
                        .collection('user_influencer')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('userInfoTable')
                        .doc('user')
                        .collection('user_influencer')
                        .where("category", arrayContainsAny: tags)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: const Text("Loading..."),
                    );
                  }
                  var docs = snapshot.data!.docs;

                  if (docs.toString() == "[]") {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: const Text("해당하는 인플루언서가 없습니다."),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: PageView.builder(
                            onPageChanged: (value) {
                              _email = docs[value]['email'];
                              print(_email);
                            },
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            pageSnapping: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  docs[index]['isOnlyImage']
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: docs[index]['PRImage'] != ''
                                              ? Image.memory(
                                                  const Base64Decoder().convert(
                                                      docs[index]['PRImage']))
                                              : const Text(
                                                  '아직 설정하신 이미지가 없습니다.'),
                                          //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
                                        )
                                      : Container(
                                    padding: EdgeInsets.only(top: 30),
                                          color : Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                // alignment: Alignment.topLeft,
                                                child: docs[index]['PRImage'] !=
                                                        ''
                                                    ? CircleAvatar(
                                                        backgroundImage: MemoryImage(
                                                            Base64Decoder()
                                                                .convert(docs[
                                                                        index][
                                                                    'PRImage']))

                                                        // Image.memory(
                                                        //     Base64Decoder()
                                                        //         .convert(docs[
                                                        //                 index][
                                                        //             'PRImage'])),
                                                        )
                                                    : const Text(
                                                        '아직 설정하신 이미지가 없습니다.'),
                                                //TODO 이미지 크기(정확히는 세로길이)가 너무 크면 OverFlow가 발생한다. 이를 방지해야 함
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              docs[index]['PRText'] != ''
                                                  ? Text(
                                                      docs[index]['PRText'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                      ),
                                                    )
                                                  : const Text(
                                                      "아직 설정하신 인사말이 없습니다.",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(

                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: docs[index]['PRAny'] !=
                                                        ''
                                                    ? Text(
                                                        docs[index]['PRAny'],
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                  textAlign: TextAlign.center,
                                                      )
                                                    : const Text(
                                                        "아직 설정하신 추가내용이 없습니다.",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                              ),
                                              const SizedBox(height: 40,),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    marginmin, 0, marginmin, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                      Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text("채널명",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold
                                                          )),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.27,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text(docs[index]
                                                          ['channelName']),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text("플랫폼", style : TextStyle(fontWeight: FontWeight.bold)),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.27,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text("platform"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    marginmin, 0, marginmin, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment:
                                                      Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text("주 컨텐츠",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                              fontWeight: FontWeight.bold
                                                          )),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.27,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text(docs[index]
                                                          ['contents']),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text("구독자 수", style : TextStyle(fontWeight: FontWeight.bold)),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.27,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: Text(docs[index]['subscribers']),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        docs[index]['email'],
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          docs[index]['platform'],
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                        )),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          docs[index]['subscribers'],
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                        )),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          docs[index]['category'].toString(),
                                          style:
                                              const TextStyle(fontSize: 15.0),
                                        )),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => detailPage_Influencer(
                                            email: _email)));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 15,
                                  shadowColor: Colors.black,
                                  side: const BorderSide(
                                      color: Colors.black, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              child: Text('자세히 보기')),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 15,
                                shadowColor: Colors.black,
                                side: const BorderSide(
                                    color: Colors.black, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            child: Text('매칭하기'),
                          ),
                        ],
                      )
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
