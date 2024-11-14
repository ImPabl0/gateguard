// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginSessionAdapter extends TypeAdapter<AuthSession> {
  @override
  final int typeId = 0;

  @override
  AuthSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthSession(
      userCPF: fields[0] as String,
      validUntil: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AuthSession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userCPF)
      ..writeByte(1)
      ..write(obj.validUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
