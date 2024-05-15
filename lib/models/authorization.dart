// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:gateguard/models/user.dart';

class Authorization {
  String fullName;
  String cpf;
  String vehiclePlate;
  User requester;
  AuthorizationStatus status;
  DateTime requestedAt;
  DateTime? updatedAt;
  AuthorizationType type;
  Authorization({
    this.fullName = "",
    this.cpf = "",
    required this.requester,
    required this.requestedAt,
    this.status = AuthorizationStatus.PENDING,
    this.type = AuthorizationType.PERSON,
    this.updatedAt,
    this.vehiclePlate = '',
  });

  String get getIdentifier {
    if (type == AuthorizationType.VEHICLE && vehiclePlate.isNotEmpty) {
      return vehiclePlate;
    }
    return fullName;
  }

  Authorization copyWith({
    String? fullName,
    String? cpf,
    User? requester,
    DateTime? requestedAt,
    DateTime? updatedAt,
    AuthorizationStatus? status,
    AuthorizationType? type,
  }) {
    return Authorization(
      fullName: fullName ?? this.fullName,
      cpf: cpf ?? this.cpf,
      requester: requester ?? this.requester,
      requestedAt: requestedAt ?? this.requestedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'cpf': cpf,
      'requester': requester.toMap(),
      'requestedAt': requestedAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory Authorization.fromMap(Map<String, dynamic> map) {
    return Authorization(
      fullName: map['fullName'] as String,
      cpf: map['cpf'] as String,
      requester: User.fromMap(map['requester'] as Map<String, dynamic>),
      requestedAt:
          DateTime.fromMillisecondsSinceEpoch(map['requestedAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      status: AuthorizationStatus.fromString(map['status'] as String),
      type: AuthorizationType.fromString(map['type'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Authorization.fromJson(String source) =>
      Authorization.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Authorization(fullName: $fullName, cpf: $cpf, requester: $requester, requestedAt: $requestedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Authorization other) {
    if (identical(this, other)) return true;

    return other.fullName == fullName &&
        other.cpf == cpf &&
        other.requester == requester &&
        other.requestedAt == requestedAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        cpf.hashCode ^
        requester.hashCode ^
        requestedAt.hashCode ^
        updatedAt.hashCode;
  }
}

enum AuthorizationStatus {
  PENDING,
  ACCEPTED,
  REJECTED;

  factory AuthorizationStatus.fromString(String string) {
    switch (string) {
      case 'PENDING':
        return AuthorizationStatus.PENDING;
      case 'ACCEPTED':
        return AuthorizationStatus.ACCEPTED;
      case 'REJECTED':
        return AuthorizationStatus.REJECTED;
      default:
        return AuthorizationStatus.PENDING;
    }
  }
}

enum AuthorizationType {
  PERSON,
  VEHICLE;

  factory AuthorizationType.fromString(String string) {
    switch (string) {
      case 'PERSON':
        return AuthorizationType.PERSON;
      case 'VEHICLE':
        return AuthorizationType.VEHICLE;
      default:
        return AuthorizationType.PERSON;
    }
  }
}
