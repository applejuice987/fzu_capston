import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//TODO!! 로그인 한 사람이 인플루언서 일 경우, 이 화면 출력

final ImagePicker _picker = ImagePicker();
dynamic _imageFile;
bool _showImage = false;
final formKey = GlobalKey<FormState>();
String Ptext = '';

class Create_Info extends StatefulWidget {
  final String prImage;
  final String prText;

  const Create_Info({Key? key, required this.prImage, required this.prText})
      : super(key: key);

  @override
  State<Create_Info> createState() => _Create_InfoState();
}

/*
class FireModel {
  String? Primage;
  String? Prtext;
  DocumentReference? reference;

  FireModel(param0, {
    this.Primage,
    this.Prtext,
  });

  FireModel.fromJson(dynamic json, this.reference) {
    Primage = json['PRImage'];
    Prtext = json['PRText'];
  }

  FireModel.fromSnapShot (DocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data(), snapshot.reference);

  FireModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>>snapshot)
      :this.fromJson(snapshot.data(), snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map ['PRImage'] = Primage;
    map ['PRText'] = Prtext;
    return map;
  }
}

class FireService{
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();

  Future createMeno(Map<String, dynamic> json) async{
    await FirebaseFirestore.instance.collection("PRText").add(json);
  }
}
*/
class _Create_InfoState extends State<Create_Info> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String _currentUser = '';

  @override
  void initState() {
    super.initState();
    _currentUser = auth.currentUser!.email.toString();
    anyController.text = '';
    prTextController.text = widget.prText;
  }

  @override
  void dispose() {
    super.dispose();
  }

  reviseButton(dynamic image) {
    return Container(
      width: 300,
      height: 40,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            // validation 이 성공하면 true 리턴
            formKey.currentState!.save();
          }

          final updateData = <String, dynamic>{
            'PRImage': !_isNoImage ? Primage(image) : "",
            'PRText': prTextController.text,
          };
          firestore
              .collection('userInfoTable')
              .doc('user')
              .collection('user_influencer')
              .doc(_currentUser)
              .update(updateData)
              .then((value) {
            Navigator.pop(context);
          });
        },
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 15,
            shadowColor: Colors.black,
            side: const BorderSide(color: Colors.black, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        child: const Text(
          '수정하기',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  String Primage(dynamic image) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var img64;
    if (image != null) {
      var bytes = File(image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    } else if (widget.prImage == '') {
      img64 = '';
    } else {
      img64 = widget.prImage;
    }
    return img64;
  }

  bool _isOnlyImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '홍보 설정하기',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5,
        ),
        backgroundColor: Color(0xffC9B9EC),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                alignment: AlignmentDirectional.center,
                child: Text('자기 PR',
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                        key: formKey,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        onSurface: Colors.grey,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(width: 0)),
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
                                            child: widget.prImage == '' &&
                                                    _imageFile == null || _isNoImage
                                                ? Text(
                                                    '+\n이미지 추가',
                                                    textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black),
                                                  )
                                                : _imageFile != null
                                                    ? Container(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(width: 3),
                                                          borderRadius: BorderRadius.circular(3)
                                                        ),
                                                        child: Image(
                                                          image: FileImage(File(
                                                              _imageFile.path)),
                                                          fit: BoxFit.cover,

                                                        ),

                                                      )
                                                    : Container(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        child: Image.memory(
                                                            Base64Decoder()
                                                                .convert(widget
                                                                    .prImage),
                                                            fit: BoxFit.cover)))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Form(
                                    child: Container(
                                      height: 500,
                                      child: Column(
                                        children: [
                                          renderTextFormField(
                                            label: '자기PR',
                                            controller: prTextController,
                                            onSaved: (val) {},
                                            validator: (val) {
                                              return null;
                                            },
                                          ),
                                          renderTextFormField(
                                            controller: anyController,
                                            label: '아무거나',
                                            onSaved: (val) {},
                                            validator: (val) {
                                              return null;
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Text("이미지만 사용"),
                                              Switch(
                                                value: _isOnlyImage,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isOnlyImage = value;
                                                  });
                                                },
                                              ),
                                              Tooltip(
                                                message:
                                                    '이미지만 사용하고 싶으신가요?\nFZU는 자유로운 자기PR 시스템을 제공합니다.\n프로필 사진이 아닌 별개의 홍보용 이미지를 등록하고\n'
                                                    '그와 동시에 홍보문구를 작성하실 수 있으며,\n자신이 꾸민 홍보용 이미지만 노출되도록 설정하실 수 있습니다.\n직접 꾸민 이미지만 사용하고 싶으시다면,'
                                                    ' 스위치를 켜 주세요.',
                                                triggerMode:
                                                    TooltipTriggerMode.tap,
                                                showDuration:
                                                    Duration(seconds: 15),
                                                child:
                                                    Icon(Icons.question_mark),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                reviseButton(_imageFile)
                              ]),
                        ))
                  ])
            ]),
          ),
        ));
  }

  List<dynamic> imageList = [];
  final prTextController = TextEditingController();
  final anyController = TextEditingController();
  bool _isNoImage = false;

  Widget bottomSheet() {
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   Navigator.of(context).pushReplacementNamed(bottomSheet().toString());
    // });

    return Container(
      height: 150,
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
                  setState(() {
                    _isNoImage = true;
                    _showImage = false;
                  });

                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 40,
                ),
                label: const Text('사진 제거'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.camera,
                  size: 40,
                ),
                label: const Text('사진 촬영'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.photo_library,
                  size: 40,
                ),
                label: const Text('사진 선택'),
              ),
            ],
          )
        ],
      ),
    );
  }

  renderTextFormField(
      {required String label,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      required TextEditingController controller}) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
            focusColor: Colors.black,
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            labelStyle: _isOnlyImage
                ? TextStyle(color: Colors.grey)
                : TextStyle(color: Colors.black),
          ),
          style: _isOnlyImage
              ? TextStyle(color: Colors.grey)
              : TextStyle(color: Colors.black),
          enabled: !_isOnlyImage,
          controller: controller,
          onSaved: onSaved,
          validator: validator,
        ),
        Container(height: 16.0),
      ],
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 30);
    setState(() {
      _imageFile = pickedFile;
      _showImage = true;
      _isNoImage = false;
    });
    imageList;
  }
}
