// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// class Page2Influencer2 extends StatefulWidget {
//   const Page2Influencer2({Key? key}) : super(key: key);
//
//   @override
//   State<Page2Influencer2> createState() => _Page2Influencer2State();
// }
//
// class _Page2Influencer2State extends State<Page2Influencer2> {
//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     return MaterialApp(
//       home: Scaffold(
//         body: Container(
//           child: CustomScrollView(
//             slivers: [
//                SliverAppBar(
//                  centerTitle: true,
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     new Container(
//                       child: Column(
//                           children:[
//                             Container(
//                               child: Text("회사명"),
//                             ),
//                             Container(
//                               child: Text("광고명"),
//                             ),
//                             Container(
//                               child: Text("광고내용"),
//                             ),
//                           ]
//                       ),
//                     ),
//                 ],
//                 ),
//
//
//
//                 floating: true,
//                 flexibleSpace: FlexibleSpaceBar(
//                    titlePadding: EdgeInsetsDirectional.only(
//                      top: AppBar().preferredSize.height,
//                      bottom: AppBar().preferredSize.height
//
//               ),
//             ),
//                 expandedHeight: 500,
//               ),
//
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) => ListTile(title: Text("지원자 목록")),
//                   childCount: 20,
//                 ),
//               ),
//               bottomNavigationBar: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: SizedBox(
//                     //height: submitButtonHeigh,
//                     child: ElevatedButton(
//                       onPressed: (){
//                         sponsorup sponsorModel1 = sponsorup(title: titlebox, content: contentbox, id: docId);
//                         sponsor.doc(docId).collection('recruit').doc(titlebox).set(sponsorModel1.toJson());
//                         user.doc('user').collection('user_sponsor').doc(docId)
//                             .update({'adList':FieldValue.arrayUnion([titlebox])});
//                         sponsor.doc('fullad').update({'adList':FieldValue.arrayUnion([titlebox])});
//                         sponsor.doc('fullad').collection('recruit').doc(titlebox).set(sponsorModel1.toJson());
//
//                         Navigator.pop(context);
//                         //sponsor.add({'title': '제목1', 'content': '내용1'});
//
//                       },
//                       style: ElevatedButton.styleFrom(
//                         textStyle: Theme.of(context).textTheme.subtitle1,
//                       ),
//                       child: Text('등록하기'),
//
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





