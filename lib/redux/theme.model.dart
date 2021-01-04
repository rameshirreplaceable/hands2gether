import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ThemeModel extends Equatable {
  String bgColor;
  String primaryColor;
  String secoundaryColor;
  String theme;
  ThemeModel({
    this.bgColor,
    this.primaryColor,
    this.secoundaryColor,
    this.theme,
  });

  ThemeModel copyWith({
    String bgColor,
    String primaryColor,
    String secoundaryColor,
    String theme,
  }) {
    return ThemeModel(
      bgColor: bgColor ?? this.bgColor,
      primaryColor: primaryColor ?? this.primaryColor,
      secoundaryColor: secoundaryColor ?? this.secoundaryColor,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bgColor': bgColor,
      'primaryColor': primaryColor,
      'secoundaryColor': secoundaryColor,
      'theme': theme,
    };
  }

  factory ThemeModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ThemeModel(
      bgColor: map['bgColor'] ?? '',
      primaryColor: map['primaryColor'] ?? '',
      secoundaryColor: map['secoundaryColor'] ?? '',
      theme: map['theme'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeModel.fromJson(String source) =>
      ThemeModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [bgColor, primaryColor, secoundaryColor, theme];
}
