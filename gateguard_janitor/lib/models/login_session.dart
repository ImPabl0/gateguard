// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gateguard/models/user.dart';
import 'package:hive/hive.dart';
part 'login_session.g.dart';

@HiveType(typeId: 0)
class AuthSession extends HiveObject {
  @HiveField(0)
  String userCPF;
  @HiveField(1)
  DateTime validUntil;
  User? user;
  AuthSession({
    required this.userCPF,
    this.user,
    required this.validUntil,
  });

  AuthSession copyWith({
    DateTime? validUntil,
    User? user,
    String? userCPF,
  }) {
    return AuthSession(
      userCPF: userCPF ?? this.userCPF,
      user: user ?? this.user,
      validUntil: validUntil ?? this.validUntil,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userCPF': userCPF,
      'validUntil': validUntil.millisecondsSinceEpoch,
    };
  }

  factory AuthSession.fromMap(Map<String, dynamic> map) {
    return AuthSession(
      userCPF: map['userCPF'] as String,
      user: User.fromMap(map['user']),
      validUntil: DateTime.fromMillisecondsSinceEpoch(map['validUntil'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthSession.fromJson(String source) =>
      AuthSession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoginSession(userCPF: $userCPF, validUntil: $validUntil)';

  @override
  bool operator ==(covariant AuthSession other) {
    if (identical(this, other)) return true;

    return other.userCPF == userCPF && other.validUntil == validUntil;
  }

  @override
  int get hashCode => userCPF.hashCode ^ validUntil.hashCode;
}
