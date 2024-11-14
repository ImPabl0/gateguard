// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  String? id;
  bool isValid;
  String janitorCpf;
  String? visitorCpf;
  DateTime validUntil;
  Invite({
    this.id,
    required this.isValid,
    required this.janitorCpf,
    this.visitorCpf,
    required this.validUntil,
  });

  Invite copyWith({
    String? id,
    bool? isValid,
    String? janitorCpf,
    String? visitorCpf,
    DateTime? validUntil,
  }) {
    return Invite(
      id: id ?? this.id,
      isValid: isValid ?? this.isValid,
      janitorCpf: janitorCpf ?? this.janitorCpf,
      visitorCpf: visitorCpf ?? this.visitorCpf,
      validUntil: validUntil ?? this.validUntil,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isValid': isValid,
      'janitorCpf': janitorCpf,
      'visitorCpf': visitorCpf,
      'validUntil': Timestamp.fromDate(validUntil),
    };
  }

  factory Invite.fromMap(Map<String, dynamic> map) {
    return Invite(
      id: map['id'],
      isValid: map['isValid'],
      janitorCpf: map['janitorCpf'],
      visitorCpf: map['visitorCpf'],
      validUntil: (map['validUntil'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Invite.fromJson(String source) =>
      Invite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invite(isValid: $isValid, janitorCpf: $janitorCpf, visitorCpf: $visitorCpf, validUntil: $validUntil)';
  }

  @override
  bool operator ==(covariant Invite other) {
    if (identical(this, other)) return true;

    return other.isValid == isValid &&
        other.janitorCpf == janitorCpf &&
        other.visitorCpf == visitorCpf &&
        other.validUntil == validUntil;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        janitorCpf.hashCode ^
        visitorCpf.hashCode ^
        validUntil.hashCode;
  }

  bool get isExpired => DateTime.now().isAfter(validUntil);
}
