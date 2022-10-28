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
  const Create_Info({Key? key}) : super(key: key);

  @override
  State<Create_Info> createState() => _Create_InfoState();
}

reviseButton(dynamic image) {
  return Container(
    width: 300,
    height: 40,
    margin: const EdgeInsets.only(top: 20),
    child: ElevatedButton(
      onPressed: () async {
        if(formKey.currentState!.validate()){
          // validation 이 성공하면 true 리턴
          formKey.currentState!.save();

        }

      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 15,
          shadowColor: Colors.black,
          side: const BorderSide(color: Colors.black, width : 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
      ),
      child: const Text(
        '수정하기',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
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

  void Primage(dynamic image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var img64;
    if (image != null) {
      var bytes = File(image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    } else {
      img64 = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffC9B9EC),
        body: SingleChildScrollView(
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
                  Form(key: formKey,
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
                                    builder: ((builder) => bottomSheet()));
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  onSurface: Colors.grey,
                                  backgroundColor: Colors.grey,
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
                                      child: _imageFile == null
                                          ? Text('+')
                                          : Image(
                                              image: FileImage(
                                                  File(_imageFile.path)),
                                            ))
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
                                      onSaved: (val) {},
                                      validator: (val) {
                                        return null;
                                      },
                                    ),
                                    renderTextFormField(
                                      label: '아무거나',
                                      onSaved: (val) {},
                                      validator: (val) {
                                        return null;
                                      },
                                    ),
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
        ));
  }

  List<dynamic> imageList = [];

  Widget bottomSheet() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(bottomSheet().toString());
    });

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

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
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
    });
    imageList;
  }
}