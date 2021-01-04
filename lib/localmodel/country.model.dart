import 'dart:convert';

class Localcountrystatemodel {
  String code2;
  String code3;
  String name;
  String capital;
  String region;
  String subregion;
  List<State> states;
  Localcountrystatemodel({
    this.code2,
    this.code3,
    this.name,
    this.capital,
    this.region,
    this.subregion,
    this.states,
  });

  Localcountrystatemodel copyWith({
    String code2,
    String code3,
    String name,
    String capital,
    String region,
    String subregion,
    List<State> states,
  }) {
    return Localcountrystatemodel(
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

  factory Localcountrystatemodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Localcountrystatemodel(
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

  factory Localcountrystatemodel.fromJson(String source) =>
      Localcountrystatemodel.fromMap(json.decode(source));

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

class State {
  String code;
  String name;
  State({
    this.code,
    this.name,
  });

  State copyWith({String code, String name}) {
    return State(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {'code': code, 'name': name};
  }

  factory State.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return State(code: map['code'] ?? '', name: map['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory State.fromJson(String source) => State.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [code, name];
}
