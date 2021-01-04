import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:hands2gether/screens/addListing_screen.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    Timer(new Duration(seconds: 1), () {
      print("Print after 2 seconds");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
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
      print("/////////////////////////////////////////////////////////////");
      print("/////////////////////////////////////////////////////////////");
      print("Redirecting to Home page");
      print("/////////////////////////////////////////////////////////////");
      print("/////////////////////////////////////////////////////////////");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
