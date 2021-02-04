import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hands2gether/auth_service.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/redux/store.dart';

class CustomAppbar extends StatefulWidget {
  CustomAppbar({Key key}) : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => AppBar(
              backgroundColor: state.theme.bgColor == '0xffffffff'
                  ? Colors.white
                  : Color(int.parse(state.theme.bgColor)),
              // backgroundColor: Color(0xFFFFFFFF),
              elevation: 0.5, // hides leading widget
              centerTitle: false,
              title: Container(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hands",
                        style: TextStyle(
                            color: Color(0xffffca39),
                            fontWeight: FontWeight.w500)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Image.asset('assets/icon/logo.png',
                          width: 30, height: 30),
                    ),
                    Text("gether",
                        style: TextStyle(
                            color: Color(0xff00b3b0),
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              iconTheme: IconThemeData(color: Color(0xffffca39)),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          // barrierColor: Colors.red,
                          // barrierColor: Colors.black.withAlpha(1),
                          builder: (BuildContext bc) {
                            return Container(
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  )),
                              child: new Wrap(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Container(
                                          child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: NetworkImage(
                                                "${_auth.currentUser.photoURL}"),
                                          ),
                                          Text(
                                              "${_auth.currentUser.displayName}",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Color(int.parse(
                                                    state.theme.primaryColor)),
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text("${_auth.currentUser.email}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w200,
                                              )),
                                        ],
                                      )),
                                      new Divider(
                                        height: 15.0,
                                        color: Color(0xfff2f2f2),
                                      ),
                                      _auth.currentUser != null
                                          ? new ListTile(
                                              leading: new Icon(
                                                Icons.perm_identity_outlined,
                                                color: Color(int.parse(
                                                    state.theme.primaryColor)),
                                              ),
                                              title: new Text('Pofile'),
                                              onTap: () => {})
                                          : SizedBox(),
                                      _auth.currentUser != null
                                          ? new ListTile(
                                              leading: new Icon(
                                                Icons.notifications_active_outlined,
                                                color: Color(int.parse(
                                                    state.theme.primaryColor)),
                                              ),
                                              title: new Text('Notification'),
                                              onTap: () => {
                                                Navigator.pushNamed(context, '/notifications')
                                              })
                                          : SizedBox(),
                                      _auth.currentUser != null
                                          ? new ListTile(
                                              leading: new Icon(
                                                Icons.invert_colors_on,
                                                color: Color(int.parse(
                                                    state.theme.primaryColor)),
                                              ),
                                              title: new Text('Change theme'),
                                              onTap: () => {
                                                StoreProvider.of<AppState>(
                                                        context)
                                                    .dispatch(UpdateSearch(
                                                        payload:
                                                            state.theme.theme ==
                                                                    'yellow'
                                                                ? "cyan"
                                                                : 'yellow')),
                                                Navigator.pop(context)
                                              },
                                              trailing: Text(
                                                state.theme.theme,
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            )
                                          : SizedBox(),
                                      new ListTile(
                                          leading: new Icon(
                                            Icons.logout,
                                            color: Color(int.parse(
                                                state.theme.primaryColor)),
                                          ),
                                          title: new Text("Logout"),
                                          onTap: () =>
                                              {AuthService().signOut(context)}),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                        // padding: EdgeInsets.only(top: 4.0),
                        child: _auth.currentUser == null
                            ? SizedBox()
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${_auth.currentUser.photoURL}"),
                              )),
                  ),
                )
              ],
            ));
  }
}
