import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Categoriesmodel extends Equatable {
  String name;
  List<String> fields;
  int id;
  Categoriesmodel({
    this.name,
    this.fields,
    this.id,
  });

  Categoriesmodel copyWith({
    String name,
    List<String> fields,
    int id,
  }) {
    return Categoriesmodel(
      name: name ?? this.name,
      fields: fields ?? this.fields,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'fields': fields,
      'id': id,
    };
  }

  factory Categoriesmodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Categoriesmodel(
      name: map['name'] ?? '',
      fields: List<String>.from(map['fields'] ?? const []),
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Categoriesmodel.fromJson(String source) =>
      Categoriesmodel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [name, fields, id];
}
