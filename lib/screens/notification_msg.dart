import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:hands2gether/common/custom_appbar.dart';
import 'package:hands2gether/common/custom_bottombar.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:hands2gether/redux/store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/firebase/services.dart';

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}

class NotificationMsgScreen extends StatefulWidget {
  final dynamic data;
  NotificationMsgScreen({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _NotificationMsgScreenState createState() => _NotificationMsgScreenState();
}

class _NotificationMsgScreenState extends State<NotificationMsgScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  Api _apiComments = locator<Api>(param1: 'comments');

  final String serverToken = 'AAAAhd68NBU:APA91bGSNeKW_krmwYTGORVRxte16g0htHSUZwnk6htSM4ODy2KQZcEJhlpvaJJJehlUOahDag40LcNq2meR_KUOaY41MQj2GgRFF2iL_Mj5WtHRj0P--2vlWfKjKzsPzEJHiLgfqdiZ';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: //////////////////////////////////////////////////////////////////");
        print(message);
        final data = message['data'];
        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:  //////////////////////////////////////////////////////////////////");
        print(message);
        final data = message['data'];
        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume:  //////////////////////////////////////////////////////////////////");
        print(message);
        final data = message['data'];
        setState(() {
          messages.add(Message(
            title: '${data['title']}',
            body: '${data['body']}',
          ));
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  Future<Map<String, dynamic>> notifyme() async {
    Timer(Duration(seconds:5), () async=>{
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'this is a body ramesh',
              'title': 'this is a title ravi'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': 'default',

              'page':'/notifications',
              'body': 'this is a body ramesh',
              'title': 'this is a title ravi'
            },
            'to': await _firebaseMessaging.getToken(),
          },
        )
      )
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
              body: ListView(
                children: messages.map(buildMessage).toList(),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                 notifyme();
                },
                label: Text('Notify'),
                icon: Icon(Icons.message),
                backgroundColor: Color(int.parse(state.theme.primaryColor)),
              ),
            ));
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
