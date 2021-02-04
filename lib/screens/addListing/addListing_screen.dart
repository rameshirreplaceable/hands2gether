import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hands2gether/model/categories.model.dart';
import 'package:hands2gether/model/listing.dart';

import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/common/custom_bottombar.dart';
import 'package:hands2gether/common/share.service.dart';
import 'package:hands2gether/localmodel/country.model.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/redux/store.dart';

class AddListingScreen extends StatefulWidget {
  AddListingScreen({Key key}) : super(key: key);

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  ShareService _sharedService = locator<ShareService>();
  Api _apiCategories = locator<Api>(param1: 'categories');
  Api _apiListing = locator<Api>(param1: 'listing');
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCountry();
    _getCategory();
  }

  Listingmodel listingmodel = new Listingmodel();
  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/json/country.json");
  }

  List _countryState = [];
  _getCountry() async {
    String data = await _loadFromAsset();
    final jsonResult = jsonDecode(data);
    List aa = [];
    for (var i in jsonResult) {
      aa.add(Localcountrymodel.fromMap(i));
    }
    setState(() {
      _countryState = aa;
    });
  }

  List _categoriesArr = [];
  _getCategory() async {
    _categoriesArr = await _sharedService.getCategories(context);
    setState(() {
      _categoriesArr = _categoriesArr;
    });
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _listingType = '0';
  var _currentSelectedCategory;
  var _currentSelectedCategoryId;
  List _subcategory = [];
  var _currentSelectedCountry;
  var _currentSelectedState;
  List sliderImage = [null, null, null, null];

  final _website = TextEditingController();
  final _donateUrl = TextEditingController();
  final _phoneNumber = TextEditingController();
  var _numberVisible = false;
  var _emailVisible = false;
  final _email = TextEditingController();

  var showStateDropdown = false;
  var _currentStateArr = [];
  var autoValidate = false;
  _submitForm() {
    setState(() {
      imgLoader = true;
    });
    var temp = [];
    print(_currentSelectedCategory);
    print(_currentSelectedCategoryId);
    print(_subcategory);

    print(_currentSelectedCountry);
    print(_currentSelectedState);
    print(_website.text);
    print(_donateUrl.text);
    print(_phoneNumber.text);
    print(_email.text);
    print(sliderImage);
    print(int.parse(_listingType));
    print(_emailVisible);
    print(_numberVisible);

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm:ss');
    String _todayDate = formatter.format(now);
    print(_todayDate);

    var _userId = _auth.currentUser.providerData[0].uid;
    print(_userId);

    temp = [
      {
        "category": _currentSelectedCategoryId,
        "country": _currentSelectedCountry,
        "state": _currentSelectedState,
        "website": _website.text,
        "url": _donateUrl.text,
        "phoneNumber": _phoneNumber.text,
        "userEmail": _email.text,
        "images": sliderImage,
        "listing": int.parse(_listingType),
        "listed": _todayDate,
        "hideemail": _emailVisible,
        "hidemobile": _numberVisible,
        "user": _userId
      }
    ];
    for (var i in _subcategory) {
      temp[0][i.fields] = i.value;
    }
    print("////////////////// Final Data ///////////////////");
    print(temp);
    _apiListing.addDocument(temp[0]).then((value) {
      setState(() {
        imgLoader = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/mylisting', (Route<dynamic> route) => false);
      print(value);
    })
    .whenComplete(() => {
        setState(() {
          imgLoader = false;
        })
      });
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, reduxstate) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, kToolbarHeight),
                child: CustomAppbar(),
              ),
              bottomNavigationBar: CustomBottombar(tabindex: 1),
              body: Container(
                child: Form(
                  autovalidate: autoValidate,
                  key: _formKey,
                  child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "LISTING TYPE",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _listingType = "0";
                                    });
                                  },
                                  child: Container(
                                    // In Need of 0
                                    margin: EdgeInsets.only(right: 2.0),
                                    decoration: BoxDecoration(
                                        color: _listingType == "0"
                                            ? Color(int.parse(
                                                reduxstate.theme.primaryColor))
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          bottomLeft: Radius.circular(15.0),
                                        )),
                                    padding: EdgeInsets.all(12.0),
                                    child: Text("In need of"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _listingType = "1";
                                    });
                                  },
                                  child: Container(
                                    // Want to Donate 1
                                    margin: EdgeInsets.only(right: 2.0),
                                    decoration: BoxDecoration(
                                      color: _listingType == "1"
                                          ? Color(int.parse(
                                              reduxstate.theme.primaryColor))
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(12.0),
                                    child: Text("Want to Donate"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.5),
                        _categorySection(reduxstate),
                        _countrySection(reduxstate),
                        SizedBox(height: 10),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.5),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                "Website",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: _website,
                                onSaved: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Website',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                "Donations URL (if any)",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                onSaved: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: _donateUrl,
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Donations URL (if any)',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              )
                            ]),
                        SizedBox(height: 10),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.5),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              MergeSemantics(
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 0.0, right: 0.0),
                                  title: Text(
                                    'Phone #',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.grey),
                                  ),
                                  trailing: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text("VISIBLE",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                                color: Colors.grey)),
                                        CupertinoSwitch(
                                          value: _numberVisible,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _numberVisible = value;
                                            });
                                          },
                                        )
                                      ]),
                                  onTap: () {
                                    setState(() {
                                      _numberVisible = !_numberVisible;
                                    });
                                  },
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  return  val == null || val == '' ? 'Please enter phonenumber' : null;
                                },
                                keyboardType: TextInputType.text,
                                controller: _phoneNumber,
                                onSaved: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Phone #',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              )
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              MergeSemantics(
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 0.0, right: 0.0),
                                  title: Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.grey),
                                  ),
                                  trailing: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text("VISIBLE",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                              color: Colors.grey)),
                                      CupertinoSwitch(
                                        value: _emailVisible,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _emailVisible = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _emailVisible = !_emailVisible;
                                    });
                                  },
                                ),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                validator: (value) => isValidEmail(value)
                                    ? null
                                    : 'Please enter a valid email address',
                                keyboardType: TextInputType.emailAddress,
                                controller: _email,
                                onSaved: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              )
                            ]),
                        SizedBox(height: 10),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.5),
                        _imageUpload(reduxstate),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.1),
                        Text(
                          "I hereby agree that submitting these details as well as displaying my personal info like mobile number / address are at my own risk and I understand that Hands2gether.org is a non-profit application and it's intention is to provide the support for the needed people and their team will not take any responsibilities, in case if there is any issue occurred due to the above provided data. Edited",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                        Divider(
                            color:
                                Color(int.parse(reduxstate.theme.primaryColor))
                                    .withOpacity(0.2),
                            thickness: 0.1),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: imgLoader == false ? 1 : 0,
                              primary: Color(
                                      int.parse(reduxstate.theme.primaryColor))
                                  .withBlue(imgLoader ? 100 : 0)),
                          onPressed: imgLoader == false
                              ? () {
                                  if (_formKey.currentState.validate() &&
                                      imgLoader == false) {
                                    print("Form Valied");
                                    _submitForm();
                                  } else {
                                    print("Form not Valied");
                                    setState(() {
                                      autoValidate = true;
                                    });
                                  }
                                }
                              : () => {},
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SUBMIT',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                imgLoader == true ? _spinnerLoader(reduxstate): SizedBox()
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ]),
                ),
              ),
            ));
  }

  _getSubCategory(reduxstate) {
    return _subcategory.length != 0
        ? Column(
            children: [
              Wrap(
                children: [
                  for (var fields in _subcategory)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          fields.fields.split("_").join(" "),
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            initialValue: fields.value,
                            onChanged: (value) {
                              var temp = [];
                              for (var i in _subcategory) {
                                if (i.fields == fields.fields) {
                                  temp.add(DynamicFields(
                                      fields: i.fields, value: value));
                                } else {
                                  temp.add(DynamicFields(
                                      fields: i.fields, value: i.value));
                                }
                              }
                              setState(() {
                                _subcategory = temp;
                              });
                            },
                            onSaved: (value) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: fields.fields.split("_").join(" "),
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.all(15),
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
              SizedBox(height: 10),
              Divider(
                  color: Color(int.parse(reduxstate.theme.primaryColor))
                      .withOpacity(0.2),
                  thickness: 0.5),
            ],
          )
        : SizedBox();
  }

  Widget _categorySection(reduxstate) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose  Category *",
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            FormField<String>(
              validator: (val) {
                var temp =
                    val == null || val == '' ? 'Please select Category' : null;
                return temp;
              },
              initialValue: _currentSelectedCategory,
              onSaved: (_) => FocusScope.of(context).nextFocus(),
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorText: state.hasError ? "Please select Category" : null,
                    isDense: true,
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(15),
                  ),
                  isEmpty: _currentSelectedCategory == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _currentSelectedCategory,
                      isDense: true,
                      isExpanded: true,
                      hint: Text("Choose  Category *",
                          style: TextStyle(fontSize: 14.0)),
                      onChanged: (String newValue) {
                        for (var i in _categoriesArr) {
                          if (i.name == newValue) {
                            List temp = [];
                            for (var k in i.fields) {
                              temp.add(DynamicFields(fields: k, value: ''));
                            }

                            setState(() {
                              _subcategory = temp;
                              _currentSelectedCategory = newValue;
                              _currentSelectedCategoryId = i.id;
                              state.didChange(newValue);
                            });
                          }
                        }
                      },
                      items: _categoriesArr.map((dynamic obj) {
                        return DropdownMenuItem<String>(
                          value: obj.name,
                          child:
                              Text(obj.name, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        _currentSelectedCategory != null
            ? _getSubCategory(reduxstate)
            : SizedBox(),
      ],
    );
  }

  Widget _countrySection(reduxstate) {
    return Column(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 10.0),
          Text(
            "Choose  Country *",
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          FormField<String>(
            validator: (val) {
              return val == null || val == '' ? 'Please select Country' : null;
            },
            onSaved: (_) => FocusScope.of(context).nextFocus(),
            initialValue: _currentSelectedCountry,
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  errorText: state.hasError ? "Please select Country" : null,
                  isDense: true,
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(15),
                ),
                isEmpty: _currentSelectedCountry == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Choose  Country *",
                        style: TextStyle(fontSize: 14.0)),
                    value: _currentSelectedCountry,
                    isDense: true,
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        _currentSelectedCountry = newValue;
                        state.didChange(newValue);
                        showStateDropdown = false;
                      });

                      Timer(
                          Duration(microseconds: 5000),
                          () => {
                                _countryState.forEach((element) {
                                  if (element.code2 == newValue) {
                                    setState(() {
                                      _currentStateArr = element.states;
                                      _currentSelectedState = null;
                                      showStateDropdown = true;
                                    });
                                  }
                                })
                              });
                    },
                    items: _countryState.map((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value.code2,
                        child:
                            Text(value.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )
        ]),
        showStateDropdown == true
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 10.0),
                Text(
                  "Choose  State *",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                Container(
                  child: FormField<String>(
                    validator: (val) {
                      return _currentStateArr.length > 0 &&
                              (val == null || val == '')
                          ? 'Please select State'
                          : null;
                    },
                    initialValue: _currentSelectedState,
                    onSaved: (_) => FocusScope.of(context).nextFocus(),
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          errorText:
                              state.hasError ? "Please select State" : null,
                          isDense: true,
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.all(15),
                        ),
                        isEmpty: _currentSelectedState == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Choose  State *",
                                style: TextStyle(fontSize: 14.0)),
                            value: _currentSelectedState,
                            isDense: true,
                            isExpanded: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _currentSelectedState = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _currentStateArr.map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(value.name,
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ])
            : SizedBox()
      ],
    );
  }

  var imgLoader = false;
  uploadImage(index) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      setState(() {
        imgLoader = true;
      });

      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      print(image);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        var rng = new Random();
        var code = rng.nextInt(900000000) + 900000000;
        var snapshot = await _storage
            .ref()
            .child('listings/handstogether_${code.toString()}')
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
        setState(() {
          sliderImage[index] = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
      setState(() {
        imgLoader = false;
      });
    } else {
      print('Grant Permissions and try again');
    }
  }

  _spinnerLoader(reduxstate) {
    return Container(
      width: 40.0,
      height: 40.0,
      margin: EdgeInsets.only(right: 20.0),
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          color: Color(int.parse(reduxstate.theme.primaryColor)),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: SpinKitCircle(
        color: Colors.white,
        size: 25.0,
      ),
    );
  }

  Widget _imageUpload(reduxstate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload pictures:",
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        SizedBox(height: 8.0),
        Wrap(
          direction: Axis.horizontal,
          children: [
            for (var index in [0, 1, 2, 3])
              imgLoader
                  ? _spinnerLoader(reduxstate)
                  : GestureDetector(
                      onTap: () {
                        uploadImage(index);
                      },
                      child: sliderImage[index] == null
                          ? Container(
                              width: 40.0,
                              height: 40.0,
                              margin: EdgeInsets.only(right: 20.0, top: 5.0),
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                  color: Color(
                                      int.parse(reduxstate.theme.primaryColor)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Icon(
                                Icons.camera_alt,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: CircleAvatar(
                                  backgroundColor: Color(int.parse(
                                          reduxstate.theme.primaryColor))
                                      .withOpacity(0.8),
                                  radius: 25.0,
                                  child: Text(
                                    '...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  backgroundImage:
                                      NetworkImage(sliderImage[index])),
                            ))
          ],
        ),
      ],
    );
  }
}

class DynamicFields {
  dynamic fields;
  dynamic value;
  DynamicFields({
    this.fields,
    this.value,
  });
  factory DynamicFields.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DynamicFields(
      fields: map['fields'],
      value: map['value'],
    );
  }
}
