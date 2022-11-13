import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fzu/login/SignUpDatabaseHelper.dart';

//TODO!! 계정 찾기. BUT 회원가입때 사용한 이메일을 가지고 만들것이기 때문에,
//TODO!! 이메일은 무조건 알고 있어야하고, 비밀번호는 찾기 시 초기화 시켜줌.

class FindAccount extends StatefulWidget {
  const FindAccount({Key? key}) : super(key: key);

  @override
  State<FindAccount> createState() => _FindAccountState();
}

class _FindAccountState extends State<FindAccount> {
  final find_pw_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          color: const Color(0xffc9b9ec),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    "아래를 통하여\n비밀번호를 재설정하세요!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Container(
                    height: 3,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: TextField(
                  controller: find_pw_controller,
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "이메일",
                      hintText: "이메일을 입력해주세요"),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onSurface: Colors.white,
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 0)
                  ),
                  onPressed: () {
                    SignUpDatabaseHelper()
                        .resetPassword(find_pw_controller.text, context);
                  },
                  child: const Text("재설정하기",style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
      ),
    );
  }
}
