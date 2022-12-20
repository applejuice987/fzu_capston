import 'dart:convert';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fzu/login/MainLoginScreen.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';

//TODO!! 여기서 인플루언서 회원가입을 진행.

class SignUpInfluencer extends StatefulWidget {
  const SignUpInfluencer({Key? key}) : super(key: key);

  @override
  State<SignUpInfluencer> createState() => _SignUpInfluencerState();


}

class _SignUpInfluencerState extends State<SignUpInfluencer> {


  String loginValue = '인플루언서';
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final platformNameController = TextEditingController();
  bool _passwordVisible = true;

  void signUpEmailAccount(dynamic image) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var img64;
    if (image != null) {
      var bytes = File(image!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
    } else {
      img64 = '';
    }
    try {
          UserCredential result = (
              await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,)
          );
          if(result.user != null) {
            auth.currentUser?.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("해당 이메일로 인증메일을 보냈습니다!")));
            auth.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainLoginScreen()),
                    (Route<dynamic> route) => false);
          }
          SignUpDatabaseHelper().backUpInfluencerData(
              email,
              platformName, img64, 'inf', channel_platformName, main_contents, category);
          // TODO!! String email, String pw, String platform, String img64, String type, String channelName, String contents
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이미 사용중인 이메일입니다.")));
        _reduplicatedEmail = true;
      } /*else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이메일 형식이 잘못되었습니다.")));
      }*/ else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("오류가 발생했습니다.")));
      }
    }

  }

  String email = '';
  String password = '';
  String passwordCheck = '';
  String platformName = '';
  String channel_platformName = '';
  String main_contents = '';
  String passwordPattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailHint = '이메일 형식으로 입력하세요.';
  String passwordHint = '8~15자의 영문, 숫자, 특수문자를 포함해주세요.';
  String passwordCheckHint = '동일한 비밀번호를 입력해주세요.';
  String platformHint = '활동하는 플랫폼명을 입력해주세요.';
  String channel_platformNameHint = '활동하는 채널/활동명을 입력해주세요. 예)프주TV';
  String main_contentsHint = '주로하는 컨텐츠를 입력해주세요.';
  bool _reduplicatedEmail = false;

  bool validatePasswordStructure(String value) { //비밀번호 조건 확인 함수
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  bool validateEmailStructure(String value) { //이메일 조건 확인 함수
    String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  // multiple choice default value
  List<String> category = [];

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
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
              focusColor: Colors.black,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              labelStyle: TextStyle(color: Colors.black),
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13),
            suffixIcon: value == 'password' || value == 'passwordCheck'? IconButton(
              icon: Icon(
                _passwordVisible? Icons.visibility_off : Icons.visibility, color: Colors.black,
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
            }
          },
          autofocus: value == 'email' ? true : false,
          obscureText: value == 'password' || value == 'passwordCheck'
          ? !_passwordVisible : false,
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
          if(formKey.currentState!.validate()){
            // validation 이 성공하면 true 가 리턴
            formKey.currentState!.save();
            signUpEmailAccount(image);
          }

        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 15,
            shadowColor: Colors.black,
            side: const BorderSide(color: Colors.black, width : 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
        ),
        child: const Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double appbarheight = AppBar().preferredSize.height;
    return Scaffold(
        backgroundColor: Color(0xffc9b9ec),
      body:  GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);

          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(height: appbarheight,),
                  SizedBox(height: 30),
                  Text("$loginValue 회원가입", textAlign: TextAlign.left, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  Container(
                    height: 3,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(key: formKey,
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Container(
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
                                side: BorderSide(width: 0)
                              ),
                              child: Stack(
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
                                      visible: true,
                                      child: _imageFile == null
                                          ? Text('+')
                                          : Image(image: FileImage(File(_imageFile.path)),)
                                  )
                                ],
                              ),
                            ),
                          ),
                            SizedBox(height: 20,),
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
                                  return '중복된 이메일입니다.';
                                }
                                return null;
                              },
                              value: 'email',
                              hint: emailHint
                            ),
                            SizedBox(height: 20,),
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
                            SizedBox(height: 20,),
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
                            SizedBox(height: 20,),
                            renderTextFormField(
                              label: '활동 플랫폼',
                              onSaved: (val) {
                                setState(() {
                                  platformName = val;
                                });
                              },
                              validator: (val) {
                                if (val.length < 1) {
                                  return '활동 플랫폼을 입력해주세요.';
                                }
                                return null;
                              },
                              value: 'platformName',
                              hint: platformHint
                            ),
                            const SizedBox(height: 20,),
                            renderTextFormField(
                                label: '채널/활동명',
                                onSaved: (val) {
                                  setState(() {
                                    channel_platformName = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '채널/활동명을 작성해주세요.';
                                  }
                                  return null;
                                },
                                value: 'channel_platformName',
                                hint: channel_platformNameHint
                            ),
                            const SizedBox(height:20),
                            renderTextFormField(
                                label: '주 컨텐츠',
                                onSaved: (val) {
                                  setState(() {
                                    main_contents = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '주 컨텐츠를 입력해주세요.';
                                  }
                                  return null;
                                },
                                value: 'platformName',
                                hint: main_contentsHint
                            ),
                          const SizedBox(height: 20,),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              child: const Text(
                                "카테고리",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          Container(
                            alignment: AlignmentDirectional.centerStart,
                            width: double.infinity,
                            child: Flexible(
                              child: ChipsChoice<String>.multiple(
                                value: category,
                                onChanged: (val) => setState(() {
                                  category = val;
                                  print(category);
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

                          renderButton(_imageFile),
                          ],
                        ),
                      )),
                ],
              ),


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
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 30);
    setState(() {
      _imageFile = pickedFile;
      _showImage = true;
    });
  }

}