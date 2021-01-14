import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/common/custom_bottombar.dart';
import 'package:hands2gether/localmodel/country.model.dart';
import 'package:hands2gether/model/listing.dart';
import 'package:hands2gether/redux/store.dart';

class AddListingScreen extends StatefulWidget {
  AddListingScreen({Key key}) : super(key: key);

  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCountry();
  }

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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Listingmodel listingmodel = new Listingmodel();
  var _currentSelectedCategory;

  var _currentSelectedCountry;

  var showStateDropdown = false;
  var _currentStateArr = [];
  var _currentSelectedState;
  var countryValue;
  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
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
              bottomNavigationBar: CustomBottombar(tabindex: 1),
              body: Container(
                child: Form(
                  key: _formKey,
                  child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        SizedBox(height: 10),
                        _categorySection(),
                        SizedBox(height: 10),
                        _countrySection(),
                        SizedBox(height: 10),
                        TextFormField(
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
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
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter URL';
                          //   }
                          //   return null;
                          // },
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
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          inputFormatters: [
                            // ignore: deprecated_member_use
                            new WhitelistingTextInputFormatter(
                                new RegExp(r'^[()\d -]{1,12}$')),
                          ],
                          keyboardType: TextInputType.phone,
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
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          // validator: (value) => isValidEmail(value)
                          //     ? null
                          //     : 'Please enter a valid email address',
                          keyboardType: TextInputType.emailAddress,
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
                        ),
                        SizedBox(height: 10),
                        Divider(color: Colors.grey[200], thickness: 0.1),
                        Text(
                          "I hereby agree that submitting these details as well as displaying my personal info like mobile number / address are at my own risk and I understand that Hands2gether.org is a non-profit application and it's intention is to provide the support for the needed people and their team will not take any responsibilities, in case if there is any issue occurred due to the above provided data. Edited",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                        Divider(color: Colors.grey[200], thickness: 0.1),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  Color(int.parse(state.theme.primaryColor))),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print("True");
                              print(listingmodel.category);
                            } else {
                              print(_formKey.currentState);
                              print("False");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Submit'),
                          ),
                        ),
                        SizedBox(height: 20),
                      ]),
                ),
              ),
            ));
  }

  Widget _categorySection() {
    var _currencies = [
      "Food",
      "Transport",
      "Personal",
      "Shopping",
      "Medical",
      "Rent",
      "Movie",
      "Salary"
    ];
    return Column(
      children: [
        FormField<String>(
          validator: (val) {
            return val == null || val == '' ? 'Please select Category' : null;
          },
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
                  hint: Text("Choose  Category *",
                      style: TextStyle(fontSize: 14.0)),
                  onChanged: (String newValue) {
                    setState(() {
                      listingmodel.category = 2;
                      _currentSelectedCategory = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: _currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        _currentSelectedCategory != null
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Summary ',
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
            : SizedBox(),
        _currentSelectedCategory != null
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Individual Organization Name',
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
            : SizedBox(),
        _currentSelectedCategory != null
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Detailed_Description',
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
            : SizedBox(),
      ],
    );
  }

  Widget _countrySection() {
    return Column(
      children: [
        FormField<String>(
          validator: (val) {
            return val == null || val == '' ? 'Please select Country' : null;
          },
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
                  onChanged: (newValue) {
                    print(newValue);
                    setState(() {
                      _currentSelectedCountry = newValue;
                      state.didChange(newValue);
                      showStateDropdown = true;
                    });

                    Timer(
                        Duration(microseconds: 5000),
                        () => {
                              _countryState.forEach((element) {
                                if (element.code2 == newValue) {
                                  setState(() {
                                    showStateDropdown = false;
                                    _currentStateArr = element.states;
                                    _currentSelectedState = '';
                                  });
                                }
                              })
                            });
                  },
                  items: _countryState.map((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value.code2,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        showStateDropdown == false
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: FormField<String>(
                  validator: (val) {
                    return val == null || val == ''
                        ? 'Please select State'
                        : null;
                  },
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
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedState = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _currentStateArr.map((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox()
      ],
    );
  }
}
