// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'roles.dart';

class User {
  String cpf;
  String fullname;
  String? email;
  String? phone;
  String password;
  String? photo;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zip;
  List<Role> role;
  User({
    required this.cpf,
    required this.fullname,
    this.email,
    this.phone,
    required this.password,
    this.photo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zip,
    required this.role,
  });

  User copyWith({
    String? cpf,
    String? fullname,
    String? email,
    String? phone,
    String? password,
    String? photo,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zip,
    List<Role>? role,
  }) {
    return User(
      cpf: cpf ?? this.cpf,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      photo: photo ?? this.photo,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zip: zip ?? this.zip,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpf': cpf,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'password': password,
      'photo': photo,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zip': zip,
      'role': role.map((x) => x.name).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      cpf: map['cpf'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      zip: map['zip'] != null ? map['zip'] as String : null,
      role: map['role'] != null
          ? List<Role>.from((map['role'] as List<dynamic>)
              .map((x) => Role.fromName(x as String)))
          : <Role>[Role.morador],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(cpf: $cpf, fullname: $fullname, email: $email, phone: $phone, password: $password, photo: $photo, address: $address, city: $city, state: $state, country: $country, zip: $zip, role: $role)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.cpf == cpf &&
        other.fullname == fullname &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.photo == photo &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.country == country &&
        other.zip == zip &&
        listEquals(other.role, role);
  }

  @override
  int get hashCode {
    return cpf.hashCode ^
        fullname.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        photo.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode ^
        zip.hashCode ^
        role.hashCode;
  }

  bool get isMorador => role.contains(Role.morador);
  bool get isPorteiro => role.contains(Role.porteiro);
  bool get isSindico => role.contains(Role.sindico);
}
