import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hands2gether/screens/listinginfo.screen.dart';
import 'package:hands2gether/screens/login_screen.dart';
import 'package:hands2gether/screens/home_screen.dart';
import 'package:hands2gether/screens/addListing_screen.dart';
import 'package:hands2gether/screens/myListing_Screen.dart';
import 'package:hands2gether/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    if (getUserInfo() != null) {
      switch (settings.name) {
        case '/':
          // return MaterialPageRoute(builder: (_) => HomeScreen());
          return MaterialPageRoute(builder: (_) => AddListingScreen());
        case '/addlisting':
          return MaterialPageRoute(builder: (_) => AddListingScreen());
        case '/mylisting':
          return MaterialPageRoute(builder: (_) => MyListingScreen());
        case '/listinginfo':
          return MaterialPageRoute(
              builder: (_) => ListingInfoScreen(data: args));
        default:
          return _errorRoute();
      }
    } else {
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }

  static getUserInfo() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("/////////////// Current  Auth User //////////////");
    print(_auth.currentUser);
    return _auth.currentUser;
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
