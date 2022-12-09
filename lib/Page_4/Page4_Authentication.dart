import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Page4_Authentication extends StatefulWidget {
  const Page4_Authentication({Key? key}) : super(key: key);

  @override
  State<Page4_Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Page4_Authentication> {
  String user = FirebaseAuth.instance.currentUser!.email.toString();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("FZU"),
          centerTitle: true,
        ),
        body: Container());
  }
}
