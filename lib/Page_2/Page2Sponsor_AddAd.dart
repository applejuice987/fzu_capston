import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';

//TODO!! 로그인 한 사람이 스폰서 일 경우, 이 화면 출력

class Page2Sponsor_AddAd extends StatefulWidget {
  const Page2Sponsor_AddAd({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor_AddAd> createState() => _Page2Sponsor_AddAdState();
}

class sponsorup {
  final String title;
  final String content;
  final String email;
  final String image;
  final List<String> applicant;
  final String duration;
  final int recruitNum;
  final bool isChecked;

  sponsorup(
      {required this.title,
      required this.content,
      required this.email,
      required this.image,
      required this.applicant,
      required this.duration,
      required this.recruitNum,
      required this.isChecked});

  sponsorup.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        email = json['email'],
        image = json['image'],
        applicant = json['applicant'],
        duration = json['duration'],
        recruitNum = json['recruitNum'],
        isChecked = json['isChecked'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'email': email,
        'image': image,
        'applicant': applicant,
        'duration': duration,
        'recruitNum': recruitNum,
        'isChecked': isChecked
      };
}

class _Page2Sponsor_AddAdState extends State<Page2Sponsor_AddAd> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  bool _showImage = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double _imageHeight = 0.0;
  int _recruitNum = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  late final String _currentUser;

  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();
  String _duration = '모집기간 설정';
  DateTimeRange? _applyDuration;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentUser = auth.currentUser!.email.toString();
    });
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  void applyDuration() async {
    _applyDuration = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1)),
        firstDate: startDate,
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month + 6, DateTime.now().day),
        saveText: "완료",
        helpText: "모집기간 설정",
        cancelText: "취소");
    // if (_applyDuration!.start.isAfter(DateTime.now())) {
    //   //TODO 늦게 시작하는 광고모집 처리
    // }
    setState(() {
      _duration =
          '${DateFormat('yyyy-MM-dd').format(_applyDuration!.start)} - ${DateFormat('yyyy-MM-dd').format(_applyDuration!.end)}';
    });
  }

  CollectionReference sponsor =
      FirebaseFirestore.instance.collection('sponsor');
  CollectionReference AdTable =
      FirebaseFirestore.instance.collection('AdTable');
  CollectionReference user =
      FirebaseFirestore.instance.collection('userInfoTable');

  void showSelectApplicantNumDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                alignment: Alignment.center, child: Text("모집인원을 선택하세요")),
            content: StatefulBuilder(builder: (context, SBsetState) {
              return NumberPicker(
                  value: _recruitNum,
                  minValue: 0,
                  maxValue: 50,
                  onChanged: (value) {
                    setState(() =>
                        _recruitNum = value); // to change on widget level state
                    SBsetState(() =>
                        _recruitNum = value); //* to change on dialog state
                  });
            }),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Scaffold(
      backgroundColor: const Color(0xffc9b9ec),
      appBar: AppBar(
        surfaceTintColor: const Color(0xffc9b9ec),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xffc9b9ec),
        title: const Text(
          "FZU",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      focusColor: Colors.black,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "제목",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    onChanged: (value) {
                      titlebox = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text("모집인원"),
                        const SizedBox(
                          width: 40,
                        ),
                        SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  showSelectApplicantNumDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Colors.black, width: 1.5),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)))),
                                child: Text(_recruitNum.toString()))),
                      ],
                    ),
                    const SizedBox(width: 40,),
                    Row(
                      children: [
                        const Text("별도 지원"),
                        Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            })
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          applyDuration();
                          print("DSFdasfsafdsafsdafas$_applyDuration");
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side:
                              const BorderSide(color: Colors.black, width: 1.5),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      child: Text(
                        _duration,
                        style: const TextStyle(color: Colors.black),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0.4),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Visibility(
                                visible: _showImage,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: _imageFile == null ? false : true,
                                  child: _imageFile == null
                                      ? const Text(
                                          '이미지 등록',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : Image(
                                          image:
                                              FileImage(File(_imageFile.path)),
                                        ))
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height * 0.6 -
                                        _imageHeight <=
                                    0
                                ? MediaQuery.of(context).size.height * 0.3
                                : MediaQuery.of(context).size.height * 0.6 -
                                    _imageHeight,
                            child: SizedBox(
                              height: double.infinity,
                              child: TextFormField(
                                maxLines: 1000,
                                controller: contentController,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                style: Theme.of(context).textTheme.bodyText1,
                                decoration: const InputDecoration.collapsed(
                                  focusColor: Colors.black,
                                  hintText: "내용",
                                  hintStyle: TextStyle(fontSize: 15),
                                ),
                                maxLength: 1000,
                                onChanged: (value) {
                                  contentbox = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            '이미지 등록',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            print('dsfdsafasdfas$_applyDuration');
                            sponsorup sponsorModel1 = sponsorup(
                                title: titlebox,
                                content: contentbox,
                                email: _currentUser,
                                applicant: [],
                                image: img64(_imageFile),
                                duration: _duration,
                                recruitNum: _recruitNum,
                                isChecked: _isChecked);
                            AdTable.doc(titlebox).set(sponsorModel1.toJson());
                            user
                                .doc('user')
                                .collection('user_sponsor')
                                .doc(docId)
                                .update({
                              'adList': FieldValue.arrayUnion([titlebox])
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 15,
                              shadowColor: Colors.black,
                              side: const BorderSide(
                                  color: Colors.black, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          child: const Text(
                            '등록하기',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 20),
      //     child: SizedBox(
      //       //height: submitButtonHeigh,
      //       child:
      //     ),
      //   ),
      // ),
    );
  }

  static String img64(dynamic image) {
    var img64;
    if (image != null) {
      var bytes = File(image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    } else {
      img64 = '';
    }
    return img64;
  }

  Widget bottomSheet() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text('사진 선택'),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.camera,
                  size: 50,
                ),
                label: const Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.photo_library,
                  size: 50,
                ),
                label: const Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 30);
    setState(() {
      _imageFile = pickedFile;
      _showImage = true;
    });
  }
}
