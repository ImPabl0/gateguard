// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gateguard/models/user.dart';

class NotificationModel {
  final String title;
  final String message;
  final bool read;
  final Timestamp createdAt;
  final User user;
  NotificationModel({
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'read': read,
      'created_at': createdAt,
      'user': user.toMap(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      message: map['message'] as String,
      read: map['read'] as bool,
      createdAt: map['created_at'],
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
