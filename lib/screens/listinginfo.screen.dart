import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'dart:ui';
import 'package:hands2gether/redux/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/model/comments.model.dart';

class ListingInfoScreen extends StatefulWidget {
  final dynamic data;
  ListingInfoScreen({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _ListingInfoScreenState createState() => _ListingInfoScreenState();
}

class _ListingInfoScreenState extends State<ListingInfoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  Api _apiComments = locator<Api>(param1: 'comments');
  var msgController = TextEditingController();

  var stopediting = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  List<Commentsmodel> oldcomments = [];
  fetchComments() async {
    List<Commentsmodel> temp = [];
    var res = await _apiComments.getDocumentByfieldsOrderby(
        "listid", widget.data.id, 'date');

    for (var val in res.docs) {
      temp.add(Commentsmodel.fromMap(val.data()));
    }
    // Comparator<Commentsmodel> priceComparator =
    //     (a, b) => a.date.compareTo(b.date);
    // temp.sort(priceComparator);
    setState(() {
      oldcomments = temp;
    });
  }

  saveComments() async {
    setState(() {
      stopediting = false;
    });
    var listId = widget.data.id;
    var userId = _auth.currentUser.providerData[0].uid;
    var photoURL = _auth.currentUser.providerData[0].photoURL;
    var displayName = _auth.currentUser.providerData[0].displayName;

    Commentsmodel data = Commentsmodel(
        comment: msgController.text,
        date: Timestamp.now(),
        listid: listId,
        userid: userId,
        displayName: displayName,
        photoURL: photoURL);

    _apiComments
        .addDocument(data.toMap())
        .then((value) => {
              msgController.clear(),
              fetchComments(),
              setState(() {
                stopediting = true;
              })
            })
        .catchError(() => {print("Error on Add comments")})
        .whenComplete(() => {
              setState(() {
                stopediting = true;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color(int.parse(state.theme.primaryColor)),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: false,
                title: Text("Details"),
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  buildSlider(widget.data),
                  SizedBox(height: 20),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.data.Summary,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.blueGrey[300],
                          ),
                          SizedBox(width: 3),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.data.Venue_Address,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blueGrey[300],
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.data.Detailed_Description,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      otherDetails("Country", widget.data.country, "State",
                          widget.data.state),
                      SizedBox(height: 10.0),
                      otherDetails("City", widget.data.city, "Venue Address",
                          widget.data.Venue_Address),
                      SizedBox(height: 10.0),
                      otherDetails("PhoneNumber", widget.data.phoneNumber,
                          "User Email", widget.data.userEmail),
                      SizedBox(height: 20.0),
                      Text(
                        "Comments",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            oldcomments.length == 0
                                ? Text("0 Comments")
                                : SizedBox(),
                            for (var i in oldcomments)
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 0),
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(int.parse(state.theme.primaryColor))
                                          .withOpacity(.8),
                                  radius: 15.0,
                                  child: Text(
                                    (i.photoURL == null || i.photoURL == '')
                                        ? i.displayName.substring(0, 1)
                                        : '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  backgroundImage: i.photoURL != null &&
                                          i.photoURL.isNotEmpty
                                      ? NetworkImage(i.photoURL)
                                      : null,
                                ),
                                title: Text(
                                  i.displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(i.comment,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )),
                              )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0.0),
                        child: TextField(
                          onSubmitted: (value) {
                            saveComments();
                          },
                          controller: msgController,
                          decoration: InputDecoration(
                            enabled: stopediting,
                            hintText: 'Add a comment . . .',
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.only(
                              left: 20,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => {saveComments()},
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 16.0, left: 24.0),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Color(
                                      int.parse(state.theme.primaryColor)),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  buildSlider(data) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: data.images != null ? data.images.length : 0,
        itemBuilder: (BuildContext context, int index) {
          var url = data.images[index];
          return Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: index == 0
                ? Hero(
                    tag: data.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      // child: Text(
                      //   data.images[index],
                      // )
                      child: url != null && url.isNotEmpty
                          ? Image.network(
                              url,
                              width: MediaQuery.of(context).size.width - 35.0,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/icon/logo.png',
                              width: MediaQuery.of(context).size.width - 35.0,
                              fit: BoxFit.contain,
                            ),
                    ),
                  )
                : ZoomIn(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      // child: Text(
                      //   data.images[index],
                      // )
                      child: url != null && url.isNotEmpty
                          ? Image.network(
                              url,
                              width: MediaQuery.of(context).size.width - 35.0,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/icon/logo.png',
                              width: MediaQuery.of(context).size.width - 35.0,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  otherDetails(name1, value1, name2, value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name1,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(value1, style: TextStyle(fontSize: 11.0))
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name2,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(value2, style: TextStyle(fontSize: 11.0))
              ],
            ),
          ),
        )
      ],
    );
  }
}
