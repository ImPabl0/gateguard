// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gateguard/models/condominium.dart';
import 'package:gateguard/models/roles.dart';

class User {
  String cpf;
  String name;
  Role role;
  Condominium? condominium;
  DateTime? birthDate;
  User({
    required this.cpf,
    required this.name,
    this.condominium,
    this.birthDate,
    this.role = Role.porteiro,
  });

  User copyWith({
    String? cpf,
    String? name,
    Condominium? condominium,
    DateTime? birthDate,
  }) {
    return User(
      cpf: cpf ?? this.cpf,
      name: name ?? this.name,
      condominium: condominium ?? this.condominium,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpf': cpf,
      'name': name,
      'condominium': condominium?.toMap(),
      'birthDate': birthDate,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      cpf: map['cpf'] ?? "",
      name: map['name'],
      birthDate: map['birthDate'],
      role: Role.fromName(map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(cpf: $cpf, name: $name, condominium: $condominium, birthDate: $birthDate)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.cpf == cpf &&
        other.name == name &&
        other.condominium == condominium &&
        other.birthDate == birthDate;
  }

  @override
  int get hashCode {
    return cpf.hashCode ^
        name.hashCode ^
        condominium.hashCode ^
        birthDate.hashCode;
  }

  get isPorteiro => role == Role.porteiro;
}
