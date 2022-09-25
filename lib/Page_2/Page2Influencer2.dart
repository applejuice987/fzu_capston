import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Page2Influencer2 extends StatefulWidget {
  const Page2Influencer2({Key? key}) : super(key: key);

  @override
  State<Page2Influencer2> createState() => _Page2Influencer2State();

}


class _Page2Influencer2State extends State<Page2Influencer2>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('회사명'),
            bottom: const TabBar(
                tabs: [Text("광고"),Text("평점")]
            ),
          ),

          body: const TabBarView(
              children: [ Text("광고"),Text("평점")]
          ),
        ),
      ),
    );
  }
}




