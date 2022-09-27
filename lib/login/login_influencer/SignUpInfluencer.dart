import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fzu/MySharedPreferences.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';
import 'package:fzu/main.dart';

//TODO!! 여기서 인플루언서 회원가입을 진행.

class SignUpInfluencer extends StatefulWidget {
  const SignUpInfluencer({Key? key}) : super(key: key);

  @override
  State<SignUpInfluencer> createState() => _SignUpInfluencerState();


}

class _SignUpInfluencerState extends State<SignUpInfluencer> {


  String loginValue = 'Influencer';
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final platformNameController = TextEditingController();
  bool _passwordVisible = false;

  void signUpEmailAccount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
          final User? user = (await
          auth.createUserWithEmailAndPassword(
            email: email,
            password: password,)
          ).user;
          MySharedPreferences.instance.setBooleanValue("loggedin", true);
          MySharedPreferences.instance.setBooleanValue("isInflu", true);
          SignUpDatabaseHelper().backUpInfluencerData(
              email, password,
              platformName);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
          const MyApp()));
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
  String passwordPattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String emailHint = '이메일 형식으로 입력하세요.';
  String passwordHint = '8~15자의 영문, 숫자, 특수문자를 포함해주세요.';
  String passwordCheckHint = '동일한 비밀번호를 입력해주세요.';
  String platformHint = '활동하는 플랫폼명을 입력해주세요.';
  bool _reduplicatedEmail = false;

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
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  bool validateEmailStructure(String value) { //이메일 조건 확인 함수
    String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return true/*regExp.hasMatch(value)*/;
    //TODO 개발용으로 무조건 조건에 맞게 수정해둠, 추후에 true를 지우고 주석을 살리면 됨
  }

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
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
            }
          },
          obscureText: value == 'password' || value == 'passwordCheck'? true : false,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
      ],
    );
  }

  renderButton() {
    return ElevatedButton(
      onPressed: () async {
        if(formKey.currentState!.validate()){
          // validation 이 성공하면 true 가 리턴
          formKey.currentState!.save();
          signUpEmailAccount();
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
          width: size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$loginValue 회원가입", textAlign: TextAlign.left, style: TextStyle(fontSize: 35),),
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
                              return '중복된 이메일입니다.';
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
                      renderButton(),
                      ],
                    ),
                  ))

            ],
          )),
    );
  }
}