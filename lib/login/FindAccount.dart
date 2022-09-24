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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("아래를 통하여 비밀번호를 재설정하세요!"),
          SizedBox(height: 50,),
          TextField(
            controller: find_pw_controller,
            decoration: const InputDecoration(
              labelText: "이메일",
              hintText: "이메일을 입력해주세요"
            ),
          ),
          ElevatedButton(onPressed: (){
            SignUpDatabaseHelper().resetPassword(find_pw_controller.text, context);
          }, child: Text("재설정하기"))
        ],
      ),
    );
  }
}
