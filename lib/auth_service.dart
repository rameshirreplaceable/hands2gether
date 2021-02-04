import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:hands2gether/common/share.service.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/screens/addListing/addListing_screen.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  ShareService _sharedService = locator<ShareService>();
  Api _userApi = locator<Api>(param1: 'users');

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('MM/dd/yyyy HH:mm:ss a');
  final String formatted = formatter.format(now);

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return TestPageOne();
        } else {
          return TestPageOne();
        }
      },
    );
  }

  //Sign Out
  signOut(context) {
    FirebaseAuth.instance.signOut();
    try {
      Timer(new Duration(seconds: 1), () {
        print("Print after 2 seconds");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
    }
  }

  //Sign in
  signIn(context) async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

  
    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      _messaging.getToken().then((token) async{
      
        var temp = {
          "token": token,
          "displayName" : _auth.currentUser.displayName ?? '',
          "email" : _auth.currentUser.email ?? '',
          "phoneNumber" : _auth.currentUser.phoneNumber ?? '',
          "photoURL" : _auth.currentUser.providerData[0].photoURL ?? '',
          "registered" : formatted,
          "uid" : _auth.currentUser.providerData[0].uid ?? '',
          "providerId" : _auth.currentUser.providerData[0].providerId ?? '',
        };
        var userLength =  await _sharedService.getUserById(context, temp['email']);
        if(userLength != null){
            temp["displayName"] = userLength.displayName ;
            temp["email"] = userLength.email;
            temp["phoneNumber"] = userLength.phoneNumber;
            temp["photoURL"] = userLength.photoURL;
            temp["registered"] = userLength.registered;
        }
        var userUpdate = await _userApi.setDocument( temp['email'], temp);
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } else {
      print("User not Logged in");
    }

  }
}

class TestPageOne extends StatelessWidget {
  const TestPageOne({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Ramesh"),
    );
  }
}
