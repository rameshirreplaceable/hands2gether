import 'dart:async';

import 'dart:convert';
import 'dart:ui';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/common/custom_bottombar.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/common/share.service.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/model/categories.model.dart';
import 'package:hands2gether/model/listing.dart';
import 'package:hands2gether/redux/store.dart';
import 'package:hands2gether/main.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _db = FirebaseFirestore.instance;
  Api _apiCategories = locator<Api>(param1: 'categories');
  Api _apiListing = locator<Api>(param1: 'listing');
  ShareService _sharedService = locator<ShareService>();

  dynamic searchValue;
  bool loader = false;
  List categoryModelList;
  List listingModelList;
  var txtField = TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), () => {fetchCategoryInfo()});
  }

  List searchResult = [];
  fetchDataSearchData(val) async {
    if (val.length > 0) {
      List _id = _categoriesArr
          .where((i) => i.name.toLowerCase().indexOf(val.toLowerCase()) != -1)
          .toList();

      List temp2 = _id.length > 0
          ? _listingsArr.where((i) => i.category == _id[0].id).toList()
          : List.empty();

      setState(() {
        searchResult = temp2;
      });
    }
  }

  List _categoriesArr = [];
  List _listingsArr = [];
  fetchCategoryInfo() async {
    setState(() {
      loader = false;
    });
    _categoriesArr = await _sharedService.getCategories(context);
    _listingsArr = await _sharedService.getListings(context);
    setState(() {
      categoryModelList = _categoriesArr;
      listingModelList = _listingsArr;
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, kToolbarHeight),
                child: CustomAppbar(),
              ),
              bottomNavigationBar: CustomBottombar(tabindex: 0),
              body: Column(
                children: [
                  AnimatedContainer(
                    height: (searchValue == null || searchValue == '')
                        ? 260.0
                        : 120.0,
                    duration: Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        Container(
                            height: 215.0,
                            width: MediaQuery.of(context).size.width,
                            // alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              color: Color(int.parse(state.theme.primaryColor)),
                              image: DecorationImage(
                                image: AssetImage('assets/img/banner1.png'),
                                fit: (searchValue == null || searchValue == '')
                                    ? BoxFit.contain
                                    : BoxFit.fitWidth,
                              ),
                            )),
                        Positioned(
                          bottom: 20.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: TextField(
                                controller: txtField,
                                onSubmitted: (value) =>
                                    fetchDataSearchData(value),
                                onChanged: (value) => {
                                  setState(() => {
                                        searchValue = value,
                                        searchResult = List.empty()
                                      })
                                },
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 22.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.1),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  isDense: true,
                                  hintText: "Eg: Blood Plasma, Jobs etc...",
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ((searchValue == null || searchValue == '') &&
                          (searchResult.length == 0))
                      ? loader == true
                          ? Expanded(
                              flex: 2,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: categoryModelList != null
                                    ? categoryModelList.length
                                    : 0,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      txtField.text = categoryModelList[i].name;
                                      setState(() => {
                                            searchValue =
                                                categoryModelList[i].name,
                                            setState(() {
                                              List a = [];
                                              searchResult = a;
                                            })
                                          });
                                      Timer(
                                          Duration(milliseconds: 400),
                                          () => {
                                                fetchDataSearchData(
                                                    categoryModelList[i].name)
                                              });
                                    },
                                    child: ZoomIn(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0,
                                            bottom: 15,
                                            left: 30,
                                            right: 30),
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(
                                                  state.theme.primaryColor))
                                              .withOpacity(.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: ListTile(
                                            title: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child: Text(
                                                categoryModelList[i].name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "In Need (200)",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Sponsor (20)",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: SpinKitCircle(
                                color:
                                    Color(int.parse(state.theme.primaryColor)),
                                size: 50.0,
                              ),
                            )
                      : loader == true
                          ? searchResult.length != 0
                              ? Expanded(
                                  flex: 2,
                                  child: ListView.builder(
                                    itemCount: searchResult.length,
                                    itemBuilder: (context, i) {
                                      return ZoomIn(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/listinginfo',
                                                arguments: searchResult[i]);
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            margin: EdgeInsets.only(
                                                top: i == 0 ? 0 : 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    leading: Hero(
                                                      tag: i,
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(
                                                                int.parse(state
                                                                    .theme
                                                                    .primaryColor))
                                                            .withOpacity(.8),
                                                        radius: 25.0,
                                                        child: Text(
                                                          searchResult[i]
                                                              .Summary
                                                              .substring(0, 1),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                        backgroundImage:
                                                            _circleImage(
                                                                searchResult[
                                                                    i]),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      searchResult[i].Summary,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                        searchResult[i]
                                                            .Detailed_Description,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                        )),
                                                  ),
                                                ),
                                                // Divider(
                                                //     color: Colors.red,
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: ZoomIn(
                                    child: Center(
                                        child: Text(
                                      ". . . No Listings Yet . . .",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.italic),
                                    )),
                                  ))
                          : Expanded(
                              flex: 2,
                              child: SpinKitCircle(
                                color:
                                    Color(int.parse(state.theme.primaryColor)),
                                size: 50.0,
                              ),
                            ),
                ],
              ),
            ));
  }

  _circleImage(listingModelList) {
    var temp = '';
    if (listingModelList.images != null &&
        listingModelList.images.length != 0) {
      for (var i in listingModelList.images) {
        if (i != null && i != '') temp = i;
      }
    }
    return temp != '' ? NetworkImage(temp) : null;
  }
}
