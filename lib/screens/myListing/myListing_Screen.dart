import 'dart:async';

import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/common/custom_bottombar.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/common/share.service.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/redux/store.dart';

class MyListingScreen extends StatefulWidget {
  MyListingScreen({Key key}) : super(key: key);

  @override
  _MyListingScreenState createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Api _apiCategories = locator<Api>(param1: 'categories');
  Api _apiListing = locator<Api>(param1: 'listing');
  ShareService _sharedService = locator<ShareService>();
  var userId;

  dynamic searchValue;
  bool loader = false;
  List categoryModelList = [];
  List listingModelList = [];
  var txtField = TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), () {
      userId = _auth.currentUser.providerData[0].uid;
      fetchUserListing();
    });
  }

  List searchResult = [];
  fetchDataSearchData(val) async {
    setState(() {
      loader = false;
    });
    if (val != '') {
      List _id = _categoriesArr
          .where((i) => i.name.toLowerCase().indexOf(val.toLowerCase()) != -1)
          .toList();

      List temp2 = _listingsArr.length > 0
          ? _listingsArr.where((i) => i.user == userId).toList()
          : List.empty();
      List temp3 = temp2.length > 0
          ? temp2.where((i) {
              print(i);
              return i.Summary.toLowerCase().indexOf(val.toLowerCase()) != -1 ||
                  (_id.length > 0 && i.category == _id[0].id);
            }).toList()
          : List.empty();
      setState(() {
        listingModelList = temp3;
        loader = true;
      });
    } else {
      List temp2 = _listingsArr.length > 0
          ? _listingsArr.where((i) => i.user == userId).toList()
          : List.empty();
      setState(() {
        listingModelList = temp2;
      });
      setState(() {
        loader = true;
      });
    }
  }

  List _categoriesArr = [];
  List _listingsArr = [];
  fetchUserListing() async {
    print(_auth);
    setState(() {
      loader = false;
    });
    _categoriesArr = await _sharedService.getCategories(context);
    _listingsArr = await _sharedService.getNewListings(context);
    List temp2 = _listingsArr.length > 0
        ? _listingsArr.where((i) => i.user == userId).toList()
        : List.empty();
    setState(() {
      categoryModelList = _categoriesArr;
      listingModelList = temp2;
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
              bottomNavigationBar: CustomBottombar(tabindex: 2),
              body: Column(
                children: [
                  AnimatedContainer(
                    height: 120.0,
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
                                fit: BoxFit.fitWidth,
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
                                // onSubmitted: (value) =>
                                //     fetchDataSearchData(value),
                                onChanged: (value) {
                                  fetchDataSearchData(value);
                                  setState(() => {
                                        searchValue = value,
                                      });
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
                  (listingModelList.length == 0 && loader == false)
                      ? Expanded(
                          flex: 2,
                          child: SpinKitCircle(
                            color: Color(int.parse(state.theme.primaryColor)),
                            size: 50.0,
                          ),
                        )
                      : listingModelList.length != 0
                          ? Expanded(
                              flex: 2,
                              child: ListView.builder(
                                itemCount: listingModelList.length,
                                itemBuilder: (context, i) {
                                  return ZoomIn(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/listinginfo',
                                            arguments: listingModelList[i]);
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
                                                      listingModelList[i]
                                                          .Summary
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                    backgroundImage:
                                                        _circleImage(
                                                            listingModelList[
                                                                i]),
                                                  ),
                                                ),
                                                title: Text(
                                                  listingModelList[i].Summary,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                    listingModelList[i]
                                                        .Detailed_Description,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                  ". . . No Listings . . .",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontStyle: FontStyle.italic),
                                )),
                              ))
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
