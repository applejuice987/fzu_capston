import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';

//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Page4_manageInfoSponsor extends StatefulWidget {
  final String currentUser;
  const Page4_manageInfoSponsor({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<Page4_manageInfoSponsor> createState() => _Page4_manageInfoSponsorState();
}

class _Page4_manageInfoSponsorState extends State<Page4_manageInfoSponsor> {

  bool validatePasswordStructure(String value) {
    //비밀번호 조건 확인 함수
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return true /*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true 지우고 주석을 살리면 됨
  }

  bool validateEmailStructure(String value) {
    //이메일 조건 확인 함수
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return true /*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true 지우고 주석을 살리면 됨
  }

  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  String profile = '';
  String password = '';
  String passwordCheck = '';
  String companyName = '';
  String ceoName = '';
  String passwordPattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailHint = '이메일 형식으로 입력하세요.';
  String passwordHint = '8~15자의 영문, 숫자, 특수문자를 포함해주세요.';
  String passwordCheckHint = '동일한 비밀번호를 입력해주세요.';
  String ceoNameHint = '사업자명을 입력해주세요.';
  String companyHint = '업체명을 입력해주세요.';
  bool _reduplicatedEmail = false;
  late FocusNode myFocusNode;
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  bool _showImage = false;
  var db = FirebaseFirestore.instance;
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController ceoNameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    db.collection('userInfoTable').doc('user').collection('user_sponsor').doc(widget.currentUser).get().then((DocumentSnapshot ds) {
      companyController.text = ds['company'];
      ceoNameController.text = ds['ceoName'];
      profile = ds['profile'];
    });
  }

  renderTextFormField(
      {required String label,
        required FormFieldSetter onSaved,
        required FormFieldValidator validator,
        required String value,
        required String hint,
        required dynamic controller}
      ) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              focusColor: Colors.black,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelStyle: const TextStyle(color: Colors.black),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13),
              suffixIcon: value == 'password' || value == 'passwordCheck'
                  ? IconButton(
                icon: Icon(
                  _passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
                  : null),
          onChanged: (text) {
            if (value == 'password') {
              password = text;
            }
          },
          obscureText: value == 'password' || value == 'passwordCheck'
              ? !_passwordVisible
              : false,
          focusNode: value == 'email' ? myFocusNode : null,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
      ],
    );
  }

  renderButton(dynamic image) {
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
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 15,
            shadowColor: Colors.black,
            side: const BorderSide(color: Colors.black, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        child: const Text(
          '변경 완료',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double appbarheight = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '내 정보 수정',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: appbarheight,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) => bottomSheet()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    side: const BorderSide(width: 0)),
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
                                            ? const Text('+\n이미지 추가', textAlign: TextAlign.center,)
                                            : Image(
                                          image: FileImage(
                                              File(_imageFile.path)),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            renderTextFormField(
                              controller: pwController,
                                label: '비밀번호 변경',
                                onSaved: (val) {
                                  setState(() {
                                    password = val as String;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '비밀번호를 입력해주세요.';
                                  } else if (val.length < 8) {
                                    return null; /*'비밀번호는 8자 이상이어야 합니다.';*/
                                    //TODO 개발용으로 조건 무조건 통과하게 만듦, 추후에 null 지우고 주석부분 살리면 됨
                                  } else if (!RegExp(passwordPattern)
                                      .hasMatch(val)) {
                                    return null; /*'비밀번호는 영문, 숫자, 특수문자를 포함하여야 합니다.';*/
                                    //TODO 개발용으로 조건 무조건 통과하게 만듦, 추후에 null 지우고 주석부분 살리면 됨
                                  }
                                  return null;
                                },
                                value: 'password',
                                hint: passwordHint),
                            const SizedBox(height: 20),
                            renderTextFormField(
                              controller: pwCheckController,
                                label: '변경 비밀번호 확인',
                                onSaved: (val) {
                                  setState(() {
                                    passwordCheck = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '비밀번호를 확인해주세요.';
                                  } else if (val != password) {
                                    return '동일한 비밀번호를 입력해주세요.';
                                  }
                                  return null;
                                },
                                value: 'passwordCheck',
                                hint: passwordCheckHint),
                            const SizedBox(height: 20),
                            renderTextFormField(
                              controller: ceoNameController,
                                label: '사업자명',
                                onSaved: (val) {
                                  setState(() {
                                    ceoName = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '사업자명을 입력해주세요.';
                                  }
                                  return null;
                                },
                                value: 'ceoName',
                                hint: ceoNameHint),
                            const SizedBox(height: 20),
                            renderTextFormField(
                              controller: companyController,
                                label: '업체명',
                                onSaved: (val) {
                                  setState(() {
                                    companyName = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '업체명을 입력해주세요.';
                                  }
                                  return null;
                                },
                                value: 'platformName',
                                hint: companyHint),
                            renderButton(_imageFile),
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
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