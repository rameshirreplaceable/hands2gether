import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Usermodel extends Equatable {
  String token;
  String displayName;
  String email;
  String phoneNumber;
  String photoURL;
  String providerId;
  String registered;
  String uid;
  Usermodel({
    this.token,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.providerId,
    this.registered,
    this.uid,
  });

  Usermodel copyWith({
    String token,
    String displayName,
    String email,
    String phoneNumber,
    String photoURL,
    String providerId,
    String registered,
    String uid,
  }) {
    return Usermodel(
      token: token ?? this.token,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      providerId: providerId ?? this.providerId,
      registered: registered ?? this.registered,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'providerId': providerId,
      'registered': registered,
      'uid': uid,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Usermodel(
      token: map['token'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      providerId: map['providerId'] ?? '',
      registered: map['registered'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) => Usermodel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      token,
      displayName,
      email,
      phoneNumber,
      photoURL,
      providerId,
      registered,
      uid,
    ];
  }
}