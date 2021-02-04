import 'dart:async';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/redux/store.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, kToolbarHeight),
                child: CustomAppbar(),
              ),
              body: Column(
                children: [
                  Container(
                    height: 300.0,
                    child: Stack(
                      children: [
                        Container(
                            height: 250.0,
                            width: MediaQuery.of(context).size.width,
                            // alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              color: Color(int.parse(state.theme.primaryColor)),
                              image: DecorationImage(
                                image: AssetImage('assets/img/banner2.png'),
                                fit: BoxFit.contain,
                              ),
                            )),
                        Positioned(
                          bottom: 25.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: TextField(
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(Icons.search),
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
                                  hintText:
                                      "Eg: Food, Blood Plasma, Jobs etc...",
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      child: Column(
                        children: [
                          Text(
                            "Authentication Required",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            "Please login to view the Listings",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(height: 10.0),
                          OutlineButton(
                            splashColor: Colors.grey,
                            onPressed: () {
                              AuthService().signIn(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: Color(0xffdfdfdf)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                    image: AssetImage(
                                        "assets/img/google_logo.png"),
                                    height: 30.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
