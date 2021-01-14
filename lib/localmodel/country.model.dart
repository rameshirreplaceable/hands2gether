import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'state.dart';

class Localcountrymodel extends Equatable {
  final String code2;
  final String code3;
  final String name;
  final String capital;
  final String region;
  final String subregion;
  final List<State> states;
  Localcountrymodel({
    @required this.code2,
    @required this.code3,
    @required this.name,
    @required this.capital,
    @required this.region,
    @required this.subregion,
    @required this.states,
  });

  Localcountrymodel copyWith({
    String code2,
    String code3,
    String name,
    String capital,
    String region,
    String subregion,
    List<State> states,
  }) {
    return Localcountrymodel(
      code2: code2 ?? this.code2,
      code3: code3 ?? this.code3,
      name: name ?? this.name,
      capital: capital ?? this.capital,
      region: region ?? this.region,
      subregion: subregion ?? this.subregion,
      states: states ?? this.states,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code2': code2,
      'code3': code3,
      'name': name,
      'capital': capital,
      'region': region,
      'subregion': subregion,
      'states': states?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Localcountrymodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Localcountrymodel(
      code2: map['code2'] ?? '',
      code3: map['code3'] ?? '',
      name: map['name'] ?? '',
      capital: map['capital'] ?? '',
      region: map['region'] ?? '',
      subregion: map['subregion'] ?? '',
      states: List<State>.from(
          map['states']?.map((x) => State.fromMap(x) ?? State()) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Localcountrymodel.fromJson(String source) =>
      Localcountrymodel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      code2,
      code3,
      name,
      capital,
      region,
      subregion,
      states,
    ];
  }
}
