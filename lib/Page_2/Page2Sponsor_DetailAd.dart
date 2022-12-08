import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Page2Sponsor_DetailAd extends StatefulWidget {
  const Page2Sponsor_DetailAd({Key? key}) : super(key: key);

  @override
  State<Page2Sponsor_DetailAd> createState() => _Page2Sponsor_DetailAdState();
}

class _Page2Sponsor_DetailAdState extends State<Page2Sponsor_DetailAd> {

  CollectionReference AdTable = FirebaseFirestore.instance.collection('AdTable');
  List<String> _applicantList= [];

  @override

  void setData() {
    AdTable.get().then((value) {
      setState(() {
        _applicantList.clear();
        for (var doc in value.docs) {
          print(doc['title']);
          _applicantList.add(doc['title'].toString());
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: const Color(0xffc9b9ec),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xffc9b9ec),
        title: const Text("FZU",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: CustomScrollView(
        slivers: [
          // SliverOverlapInjector(
          //   handle:
          //   NestedScrollView.sliverOverlapAbsorberHandleFor(
          //       context),
          // ),
          SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(30),
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("회사명",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("제목 : ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㄹ",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal)),
                        Spacer(),
                        Text("지원자 수 : 200",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal))
                      ],
                    ),
                    Text("내용",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal))
                  ],
                ),
              )
          ),
          // SliverOverlapInjector(
          //   handle:
          //   NestedScrollView.sliverOverlapAbsorberHandleFor(
          //       context),
          // ),
          const SliverPersistentHeader(
              pinned: true, delegate: CategoryBreadcrumbs()),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                      GestureDetector(
                        onTap: (){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$index")));
                        },
                        child: Card(
                          margin: const EdgeInsets.all(15),
                          // 보는 재미를 위해 인덱스에 아무 숫자나 곱한 뒤 255로
                          // 나눠 다른 색이 보이도록 함.
                          child: Container(
                            alignment: Alignment.center,
                            height: 80,
                            color: Colors.blue[100 * (index % 9 + 1)],
                            child: Text("Item $index"),
                          ),
                        ),
                      ),
                  childCount: 20))
        ],
      ),
    );
    // return MaterialApp(
    //   home: Scaffold(
    //     body: Container(
    //       child: CustomScrollView(
    //         slivers: [
    //            SliverAppBar(
    //              centerTitle: true,
    //             title: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 new Container(
    //                   child: Column(
    //                       children:[
    //                         Container(
    //                           child: Text("회사명"),
    //                         ),
    //                         Container(
    //                           child: Text("광고명"),
    //                         ),
    //                         Container(
    //                           child: Text("광고내용"),
    //                         ),
    //                       ]
    //                   ),
    //                 ),
    //             ],
    //             ),
    //
    //
    //
    //             floating: true,
    //             flexibleSpace: FlexibleSpaceBar(
    //                titlePadding: EdgeInsetsDirectional.only(
    //                  top: AppBar().preferredSize.height,
    //                  bottom: AppBar().preferredSize.height
    //
    //           ),
    //         ),
    //             expandedHeight: 500,
    //           ),
    //
    //           SliverList(
    //             delegate: SliverChildBuilderDelegate(
    //                   (context, index) => ListTile(title: Text("지원자 목록")),
    //               childCount: 20,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
class CategoryBreadcrumbs extends SliverPersistentHeaderDelegate {
  const CategoryBreadcrumbs();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text("지원목록", style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.normal)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Center(child: Text("전체보기")),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}











