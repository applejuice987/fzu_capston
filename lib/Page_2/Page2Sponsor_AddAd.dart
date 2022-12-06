//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/Page_2/Page2Sponsor_DetailAd.dart';
import 'package:image_picker/image_picker.dart';

import 'Page2Sponsor.dart';

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


  sponsorup({required this.title, required this.content, required this.email, required this.image, required this.applicant});

  sponsorup.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        email = json['email'],
        image = json['image'],
        applicant = json['applicant'];

  Map<String, dynamic> toJson() =>
      {'title': title, 'content': content, 'email': email, 'image': image, 'applicant': applicant};
}

class _Page2Sponsor_AddAdState extends State<Page2Sponsor_AddAd> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  bool _showImage = false;
  DateTime startDate = DateTime(0, 0, 0);
  DateTime endDate = DateTime(0, 0, 0);

  FirebaseAuth auth = FirebaseAuth.instance;
  late final String _currentUser;

  late String titlebox;
  late String contentbox;
  late String docId = auth.currentUser!.email.toString();

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

  CollectionReference sponsor =
      FirebaseFirestore.instance.collection('sponsor');
  CollectionReference AdTable =
      FirebaseFirestore.instance.collection('AdTable');
  CollectionReference user =
      FirebaseFirestore.instance.collection('userInfoTable');


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
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: MediaQuery.of(context).size.height * 0.66,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
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
                            borderRadius: BorderRadius.circular(10)
                          )
                          ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Visibility(
                              visible: _showImage,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: true,
                                child: _imageFile == null
                                    ? const Text('이미지 등록',style: TextStyle(color: Colors.black),)
                                    : Image(
                                  image: FileImage(
                                      File(_imageFile.path)),
                                ))
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            var bytes = File(_imageFile!.path).readAsBytesSync();
                            String image = base64Encode(bytes);
                            sponsorup sponsorModel1 = sponsorup(
                                title: titlebox,
                                content: contentbox,
                                email: _currentUser,
                                image: image,
                                applicant: []);
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
