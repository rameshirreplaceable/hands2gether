import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Commentsmodel extends Equatable {
  String comment;
  Timestamp date;
  String listid;
  String userid;
  String displayName;
  String photoURL;
  Commentsmodel({
    this.comment,
    this.date,
    this.listid,
    this.userid,
    this.displayName,
    this.photoURL,
  });

  Commentsmodel copyWith({
    String comment,
    Timestamp date,
    String listid,
    String userid,
  }) {
    return Commentsmodel(
      comment: comment ?? this.comment,
      date: date ?? this.date,
      listid: listid ?? this.listid,
      userid: userid ?? this.userid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'date': date,
      'listid': listid,
      'userid': userid,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  factory Commentsmodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Commentsmodel(
      comment: map['comment'] ?? '',
      date: map['date'] ?? '',
      listid: map['listid'] ?? '',
      userid: map['userid'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Commentsmodel.fromJson(String source) =>
      Commentsmodel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [comment, date, listid, userid, displayName, photoURL];
}
