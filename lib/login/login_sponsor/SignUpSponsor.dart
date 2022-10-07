import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/main.dart';
import 'package:image_picker/image_picker.dart';

//TODO!! 여기서 광고주의 회원가입을 진행.

class SignUpSponsor extends StatefulWidget {
  const SignUpSponsor({Key? key}) : super(key: key);

  @override
  State<SignUpSponsor> createState() => _SignUpSponsorState();
}

class _SignUpSponsorState extends State<SignUpSponsor> {

  String loginValue = 'Sponsor';
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final companyNameController = TextEditingController();

  void signUpEmailAccount(dynamic image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var img64;
    if (image != null) {
      var bytes = File(image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    }
    try {
            final User? user = (await
            auth.createUserWithEmailAndPassword(
              email: email,
              password: password,)
            ).user;
            MySharedPreferences.instance.setBooleanValue("loggedin", true);
            MySharedPreferences.instance.setBooleanValue("isInflu", false);
            SignUpDatabaseHelper().backUpSponsorData(
                email, password,
                companyName, img64);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()),(Route<dynamic> route) => false);

  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이미 사용중인 이메일입니다.")));
    setState(() {
      _reduplicatedEmail = true;
      myFocusNode.requestFocus();
    });

    } /*else if (e.code == 'invalid-email') {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이메일 형식이 잘못되었습니다.")));
    } */
    else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("오류가 발생했습니다.")));
    }
    }

  }

  void flutterToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  bool validatePasswordStructure(String value) { //비밀번호 조건 확인 함수
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true 지우고 주석을 살리면 됨
  }

  bool validateEmailStructure(String value) { //이메일 조건 확인 함수
    String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true 지우고 주석을 살리면 됨
  }

  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String email = '';
  String password = '';
  String passwordCheck = '';
  String companyName = '';
  String passwordPattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailHint = '이메일 형식으로 입력하세요.';
  String passwordHint = '8~15자의 영문, 숫자, 특수문자를 포함해주세요.';
  String passwordCheckHint = '동일한 비밀번호를 입력해주세요.';
  String companyHint = '업체명을 입력해주세요.';
  bool _reduplicatedEmail = false;
  late FocusNode myFocusNode;
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    required String value,
    required String hint
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
            )
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13),
              suffixIcon: value == 'password' || value == 'passwordCheck'? IconButton(
                icon: Icon(
                    _passwordVisible? Icons.visibility_off : Icons.visibility
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;

                  });
                },
              ) : null
          ),
          onChanged: (text) {
            if (value == 'password') {
              password = text;
            } else if (value == 'email') {
              setState(() {
                _reduplicatedEmail = false;
              });

            }
          },
          autofocus: value == 'email' ? true : false,
          obscureText: value == 'password' || value == 'passwordCheck'? !_passwordVisible : false,
          focusNode: value == 'email' ? myFocusNode : null,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
      ],
    );
  }

  renderButton(dynamic image) {
    return ElevatedButton(
      onPressed: () async {
        if(formKey.currentState!.validate()){
          // validation 이 성공하면 true 리턴
          formKey.currentState!.save();
          signUpEmailAccount(image);
        }

      },
      child: Text(
        '회원가입',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$loginValue 회원가입", textAlign: TextAlign.left, style: TextStyle(fontSize: 40),),
              Form(key: formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        renderTextFormField(
                            label: 'Email',
                            onSaved: (val) {
                              setState(() {
                                email = val as String;
                              });
                            },
                            validator: (val) {
                              if (val.length < 1) {
                                return '이메일 주소를 입력해주세요.';
                              }
                              else if (!RegExp(emailPattern).hasMatch(val)) {
                                return '이메일 형식이 잘못되었습니다.';
                              }
                              else if (_reduplicatedEmail) {
                                return '이미 사용중인 이메일입니다.';
                              }
                              return null;
                            },
                            value: 'email',
                            hint: emailHint
                        ),
                        renderTextFormField(
                            label: 'Password',
                            onSaved: (val) {
                              setState(() {
                                password = val as String;
                              });
                            },
                            validator: (val) {
                              if (val.length < 1) {
                                return '비밀번호를 입력해주세요.';
                              }
                              else if(val.length < 8) {
                                return null;/*'비밀번호는 8자 이상이어야 합니다.';*/
                                //TODO 개발용으로 조건 무조건 통과하게 만듦, 추후에 null 지우고 주석부분 살리면 됨
                              }
                              else if (!RegExp(passwordPattern).hasMatch(val)) {
                                return null;/*'비밀번호는 영문, 숫자, 특수문자를 포함하여야 합니다.';*/
                                //TODO 개발용으로 조건 무조건 통과하게 만듦, 추후에 null 지우고 주석부분 살리면 됨
                              }
                              return null;
                            },
                            value: 'password',
                            hint: passwordHint
                        ),
                        renderTextFormField(
                            label: 'Password 확인',
                            onSaved: (val) {
                              setState(() {
                                passwordCheck = val;
                              });
                            },
                            validator: (val) {
                              if (val.length < 1) {
                                return '비밀번호를 확인해주세요.';
                              }
                              else if(val != password) {
                                return '동일한 비밀번호를 입력해주세요.';
                              }
                              return null;
                            },
                            value: 'passwordCheck',
                            hint: passwordCheckHint
                        ),
                        renderTextFormField(
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
                            hint: companyHint
                        ),
                        renderButton(_imageFile),
                      ],
                    ),
                  ))
            ],
          )),
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
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 30);
    setState(() {
      _imageFile = pickedFile;
      _showImage = true;
    });
  }

}
