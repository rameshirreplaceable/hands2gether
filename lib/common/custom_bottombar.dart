import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/redux/store.dart';

class CustomBottombar extends StatefulWidget {
  final int tabindex;
  CustomBottombar({Key key, @required this.tabindex}) : super(key: key);

  @override
  _CustomBottombarState createState() => _CustomBottombarState();
}

class _CustomBottombarState extends State<CustomBottombar> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int tabindex;

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
    if (index == 1) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/addlisting', (Route<dynamic> route) => false);
    }
    if (index == 2) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/mylisting', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null
        ? StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) => BottomNavigationBar(
              selectedItemColor: Color(int.parse(state.theme.primaryColor)),
              onTap: onTabTapped,
              currentIndex: widget.tabindex, // new
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.add_circle_outline_rounded),
                  title: new Text('Add Listing'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt_outlined),
                    title: Text("My Listing's"))
              ],
            ),
          )
        : SizedBox();
  }
}
