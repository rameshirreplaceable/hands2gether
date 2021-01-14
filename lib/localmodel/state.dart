import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class State extends Equatable {
  final String code;
  final String name;
  State({
    @required this.code,
    @required this.name,
  });

  State copyWith({
    String code,
    String name,
  }) {
    return State(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
    };
  }

  factory State.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return State(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory State.fromJson(String source) => State.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [code, name];
}
