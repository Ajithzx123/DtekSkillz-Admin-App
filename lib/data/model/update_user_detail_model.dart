// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UpdateUserDetails {
  final String? username;
  final String? email;
  final String? phone;
  final String? countryCode;
  final dynamic image;
  //AAA
  final String? industry;
  final String? division;
  final String? noOfYears;
  final String? typeOfServices;

  UpdateUserDetails({
    this.username,
    this.email,
    this.phone,
    this.countryCode,
    this.image,
    //AAA
    this.division,
    this.industry,
    this.noOfYears,
    this.typeOfServices,
  });

  UpdateUserDetails copyWith({
    final String? username,
    final String? email,
    final String? phone,
    final String? countryCode,
    final image,
    //AAA
    final String? industry,
    final String? division,
    final String? noOfYears,
    final String? typeOfServices,
  }) =>
      UpdateUserDetails(
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
        image: image ?? this.image,
        //AAA
        industry: industry ?? this.industry,
        division: division ?? this.division,
        noOfYears: noOfYears ?? this.noOfYears,
        typeOfServices: typeOfServices ?? this.typeOfServices,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        "username": username,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "image": image,
        //AAA
        "industry": industry,
        "division": division,
        "no_of_year_industry": noOfYears,
        "type_of_service": typeOfServices,
      };

  String toJson() => json.encode(toMap());

  factory UpdateUserDetails.fromMap(final Map<String, dynamic> map) =>
      UpdateUserDetails(
        username: map["username"] != null ? map["username"] as String : null,
        email: map["email"] != null ? map["email"] as String : null,
        phone: map["phone"] != null ? map["phone"] as String : null,
        image: map["image"] as dynamic,
        //AAA
        industry: map["industry"] != null ? map["industry"] as String : null,
        division: map["division"] != null ? map["division"] as String : null,
        noOfYears: map["no_of_year_industry"] != null
            ? map["no_of_year_industry"] as String
            : null,
        typeOfServices: map["type_of_service"] != null
            ? map["type_of_service"] as String
            : null,
      );

  factory UpdateUserDetails.fromJson(final String source) =>
      UpdateUserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is UpdateUserDetails &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.image == image &&
        //AAA
        other.industry == industry &&
        other.division == division &&
        other.noOfYears == noOfYears &&
        other.typeOfServices == typeOfServices;
  }

  @override
  int get hashCode =>
      username.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      image.hashCode ^
      //AAA
      industry.hashCode ^
      division.hashCode ^
      noOfYears.hashCode ^
      typeOfServices.hashCode;
}
