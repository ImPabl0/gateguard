// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Condominium {
  String name;
  String status;
  Condominium({
    required this.name,
    required this.status,
  });

  Condominium copyWith({
    String? name,
    String? status,
  }) {
    return Condominium(
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'status': status,
    };
  }

  factory Condominium.fromMap(Map<String, dynamic> map) {
    return Condominium(
      name: map['name'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Condominium.fromJson(String source) =>
      Condominium.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Condominium(name: $name, status: $status)';

  @override
  bool operator ==(covariant Condominium other) {
    if (identical(this, other)) return true;

    return other.name == name && other.status == status;
  }

  @override
  int get hashCode => name.hashCode ^ status.hashCode;
}
