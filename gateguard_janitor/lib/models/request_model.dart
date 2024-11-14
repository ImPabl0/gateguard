// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gateguard/models/user.dart';

class Request {
  String id;
  String description;
  String title;
  String guestName;
  AuthorizationType type;
  AuthorizationStatus status;
  User? requester;
  DateTime? updatedAt;
  DateTime createdAt;
  Request({
    required this.id,
    required this.description,
    required this.title,
    required this.type,
    required this.status,
    this.requester,
    this.guestName = '',
    this.updatedAt,
    required this.createdAt,
  });

  Request copyWith({
    String? id,
    String? description,
    String? title,
    AuthorizationType? type,
    AuthorizationStatus? status,
    User? requester,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Request(
      id: id ?? this.id,
      description: description ?? this.description,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      requester: requester ?? this.requester,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'title': title,
      'type': type.name,
      'guest_name': guestName,
      'status': status.name.toUpperCase(),
      'requester': requester?.toMap(),
      'updated_at': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      description: map['description'],
      guestName: map['guest_name'] ?? "DESCONHECIDO",
      title: map['title'],
      type: AuthorizationType.fromString(map['type']),
      status: AuthorizationStatus.fromString(map['status']),
      requester: map['requester'] != null
          ? User.fromMap(map['requester'] as Map<String, dynamic>)
          : null,
      updatedAt: map['updated_at'] == null
          ? null
          : (map['updated_at'] as Timestamp).toDate(),
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Requests(id: $id, description: $description, title: $title, type: $type, status: $status, requester: $requester, updated_at: $updatedAt, created_at: $createdAt)';
  }

  @override
  bool operator ==(covariant Request other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.title == title &&
        other.type == type &&
        other.status == status &&
        other.requester == requester &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        title.hashCode ^
        type.hashCode ^
        status.hashCode ^
        requester.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }
}

enum AuthorizationStatus {
  PENDING,
  ACCEPTED,
  DENIED;

  factory AuthorizationStatus.fromString(String string) {
    switch (string.toUpperCase()) {
      case 'PENDING':
        return AuthorizationStatus.PENDING;
      case 'APPROVED':
        return AuthorizationStatus.ACCEPTED;
      case 'DENIED':
        return AuthorizationStatus.DENIED;
      default:
        return AuthorizationStatus.PENDING;
    }
  }
}

enum AuthorizationType {
  PERSON,
  VEHICLE;

  factory AuthorizationType.fromString(String string) {
    switch (string.toUpperCase()) {
      case 'PERSON':
        return AuthorizationType.PERSON;
      case 'VEHICLE':
        return AuthorizationType.VEHICLE;
      default:
        return AuthorizationType.PERSON;
    }
  }
}
