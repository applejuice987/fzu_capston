import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
//TODO!! 로그인 한 사람이 광고주 일 경우, 이 화면 출력

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}

class Page1SponsorMenu extends StatefulWidget {
  const Page1SponsorMenu({
    Key? key,
  }) : super(key: key);

  // final String title;
  @override
  State<Page1SponsorMenu> createState() => _Page1SponsorState();
}

class _Page1SponsorState extends State<Page1SponsorMenu> {
  static final List<Category> _Cates = [
    Category(id: 1, name: "Car"),
    Category(id: 2, name: "Song"),
    Category(id: 3, name: "Passion"),
    Category(id: 5, name: "Travel"),
    Category(id: 6, name: "Dance"),
    Category(id: 7, name: "Art"),
    Category(id: 8, name: "Art"),
    Category(id: 9, name: "Art"),
    Category(id: 10, name: "Art"),
    Category(id: 11, name: "Art"),
    Category(id: 12, name: "Art"),
    Category(id: 13, name: "Art"),
    Category(id: 14, name: "Art"),
    Category(id: 15, name: "Art"),
    Category(id: 16, name: "Art"),
    Category(id: 17, name: "Art"),
    Category(id: 18, name: "Art"),
    Category(id: 19, name: "Art"),
    Category(id: 20, name: "Art"),
    Category(id: 21, name: "Art"),
    Category(id: 22, name: "Art"),
    Category(id: 23, name: "Art"),
    Category(id: 24, name: "Art"),
    Category(id: 25, name: "Art"),
    Category(id: 26, name: "Art"),
    Category(id: 27, name: "Art"),
  ];
  final _items =
      _Cates.map((Cates) => MultiSelectItem<Category>(Cates, Cates.name))
          .toList();

  // List<Category> _selectedAnimals = [];
  List<Category> _selectedAnimals2 = [];
  List<Category> _selectedAnimals3 = [];

  //List<Category> _selectedAnimals4 = [];
  List<Category> _selectedAnimals5 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _selectedAnimals5 = _Cates;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              //################################################################################################
              // Rounded blue MultiSelectDialogField
              //################################################################################################
              MultiSelectDialogField(
                items: _items,
                title: Text("Category"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.pets,
                  color: Colors.blue,
                ),
                buttonText: Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                },
              ),
              SizedBox(height: 50),
              //################################################################################################
              // This MultiSelectBottomSheetField has no decoration, but is instead wrapped in a Container that has
              // decoration applied. This allows the ChipDisplay to render inside the same Container.
              //################################################################################################
/*
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.4),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: Text("Category"),
                      title: Text("Animals"),
                      items: _items,
                      onConfirm: (values) {
                        //   _selectedAnimals2 = values;
                      },
                      */

                      /*

                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            _selectedAnimals2.remove(value);
                          });
                        },
                      ),
                    ),


                    _selectedAnimals2 == null || _selectedAnimals2.isEmpty
                        ? Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "None selected",
                          style: TextStyle(color: Colors.black54),
                        ))

                        */




              /*
              //################################################################################################
              // MultiSelectBottomSheetField with validators
              //################################################################################################
              MultiSelectBottomSheetField<Category>(
                key: _multiSelectKey,
                initialChildSize: 0.7,
                maxChildSize: 0.95,
                title: Text("Animals"),
                buttonText: Text("Favorite Animals"),
                items: _items,
                searchable: true,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Required";
                  }
                  List<String> names = values.map((e) => e.name).toList();
                  if (names.contains("Frog")) {
                    return "Frogs are weird!";
                  }
                  return null;
                },
                onConfirm: (values) {
                  setState(() {
                    _selectedAnimals3 = values;
                  });
                 // _multiSelectKey.currentState.validate();
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (item) {
                    setState(() {
                      _selectedAnimals3.remove(item);
                    });
                //    _multiSelectKey.currentState.validate();
                  },
                ),
              ),
              SizedBox(height: 40),
              //################################################################################################
              // MultiSelectChipField
              //################################################################################################
              MultiSelectChipField(
                items: _items,
                initialValue: [_Cates[4], _Cates[5],
                      _Cates[9]
                    ],
                    title: Text("Animals"),
                headerColor: Colors.blue.withOpacity(0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1.8),
                ),
                selectedChipColor: Colors.blue.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.blue[800]),
                onTap: (values) {
                  //_selectedAnimals4 = values;
                },
              ),
              SizedBox(height: 40),
              //################################################################################################
              // MultiSelectDialogField with initial values
              //################################################################################################
              MultiSelectDialogField(
                onConfirm: (val) {
              //    _selectedAnimals5 = val;
                },
                dialogWidth: MediaQuery.of(context).size.width * 0.7,
                items: _items,
                initialValue:
                _selectedAnimals5, // setting the value of this in initState() to pre-select values.
              ),

              */
            ],
          ),
        ),
      ),
    );
  }
}
