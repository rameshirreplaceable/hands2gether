import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Listingmodel extends Equatable {
  String state;
  dynamic hidemobile;
  dynamic hideemail;
  String country;
  String website;
  String Venue_Address;
  String phoneNumber;
  String Detailed_Description;
  String Individual_Organization_Name;
  int listing;
  String id;
  int category;
  List<String> images;
  String listed;
  String user;
  String city;
  String userEmail;
  String url;
  String Summary;
  int status;
  Listingmodel({
    this.state,
    this.hidemobile,
    this.hideemail,
    this.country,
    this.website,
    this.Venue_Address,
    this.phoneNumber,
    this.Detailed_Description,
    this.Individual_Organization_Name,
    this.listing,
    this.id,
    this.category,
    this.images,
    this.listed,
    this.user,
    this.city,
    this.userEmail,
    this.url,
    this.Summary,
    this.status,
  });

  Listingmodel copyWith({
    String state,
    dynamic hidemobile,
    dynamic hideemail,
    String country,
    String website,
    String Venue_Address,
    String phoneNumber,
    String Detailed_Description,
    String Individual_Organization_Name,
    int listing,
    String id,
    int category,
    List<String> images,
    String listed,
    String user,
    String city,
    String userEmail,
    String url,
    String Summary,
    int status,
  }) {
    return Listingmodel(
      state: state ?? this.state,
      hidemobile: hidemobile ?? this.hidemobile,
      hideemail: hideemail ?? this.hideemail,
      country: country ?? this.country,
      website: website ?? this.website,
      Venue_Address: Venue_Address ?? this.Venue_Address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      Detailed_Description: Detailed_Description ?? this.Detailed_Description,
      Individual_Organization_Name:
          Individual_Organization_Name ?? this.Individual_Organization_Name,
      listing: listing ?? this.listing,
      id: id ?? this.id,
      category: category ?? this.category,
      images: images ?? this.images,
      listed: listed ?? this.listed,
      user: user ?? this.user,
      city: city ?? this.city,
      userEmail: userEmail ?? this.userEmail,
      url: url ?? this.url,
      Summary: Summary ?? this.Summary,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state': state,
      'hidemobile': hidemobile,
      'hideemail': hideemail,
      'country': country,
      'website': website,
      'Venue_Address': Venue_Address,
      'phoneNumber': phoneNumber,
      'Detailed_Description': Detailed_Description,
      'Individual_Organization_Name': Individual_Organization_Name,
      'listing': listing,
      'id': id,
      'category': category,
      'images': images,
      'listed': listed,
      'user': user,
      'city': city,
      'userEmail': userEmail,
      'url': url,
      'Summary': Summary,
      'status': status,
    };
  }

  factory Listingmodel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Listingmodel(
      state: map['state'] ?? '',
      hidemobile: map['hidemobile'] ?? false,
      hideemail: map['hideemail'] ?? false,
      country: map['country'] ?? '',
      website: map['website'] ?? '',
      Venue_Address: map['Venue_Address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      Detailed_Description: map['Detailed_Description'] ?? '',
      Individual_Organization_Name: map['Individual_Organization_Name'] ?? '',
      listing: map['listing']?.toInt() ?? 0,
      id: map['id'] ?? '',
      category: map['category']?.toInt() ?? 0,
      images: List<String>.from(map['images'] ?? const []),
      listed: map['listed'] ?? '',
      user: map['user'] ?? '',
      city: map['city'] ?? '',
      userEmail: map['userEmail'] ?? '',
      url: map['url'] ?? '',
      Summary: map['Summary'] ?? '',
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Listingmodel.fromJson(String source) =>
      Listingmodel.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      state,
      hidemobile,
      hideemail,
      country,
      website,
      Venue_Address,
      phoneNumber,
      Detailed_Description,
      Individual_Organization_Name,
      listing,
      id,
      category,
      images,
      listed,
      user,
      city,
      userEmail,
      url,
      Summary,
      status,
    ];
  }
}
