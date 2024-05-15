import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:gateguard/models/login_session.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';

class AuthRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  LoginSession? _loginSession;
  Box<LoginSession>? loginBox;

  LoginSession? get loginSession => _loginSession?.copyWith();

  Future<void> _loadLoginSession() async {
    loginBox ??= await Hive.openBox<LoginSession>("loginSession");
    _loginSession = loginBox!.get(1);
  }

  Future<void> logout() async {
    loginBox ??= await Hive.openBox<LoginSession>("loginSession");
    loginBox!.delete(1);
  }

  Future<bool> checkLoginSession() async {
    await _loadLoginSession();
    if (_loginSession == null) {
      return false;
    }
    if (_loginSession!.validUntil.isBefore(DateTime.now())) {
      await logout();
      return false;
    }
    User? foundUser = await findUserByCpf(_loginSession!.userCPF);
    if (foundUser == null) {
      return false;
    }
    _loginSession!.user = foundUser;
    return true;
  }

  Future<User?> findUserByCpf(String cpf) async {
    DatabaseReference userRef = _database.ref("users");
    DatabaseEvent snapshot =
        await userRef.orderByChild("cpf").equalTo(cpf).once();
    if (snapshot.snapshot.value == null) {
      return null;
    }
    List<Object?> users = snapshot.snapshot.value as List<Object?>;
    LinkedHashMap map = users[0] as LinkedHashMap;
    Map convertedMap = map.cast<String, dynamic>();
    User foundUser = User.fromMap(convertedMap as Map<String, dynamic>);
    return foundUser;
  }

  Future<User?> findUserByCpfAndSenha(String cpf, String senha) async {
    DatabaseReference userRef = _database.ref("users");
    DatabaseEvent snapshot =
        await userRef.orderByChild("cpf").equalTo(cpf).once();
    if (snapshot.snapshot.value == null) {
      return null;
    }

    List<Object?> users = snapshot.snapshot.value as List<Object?>;
    LinkedHashMap map = users[0] as LinkedHashMap;
    Map convertedMap = map.cast<String, dynamic>();

    if (convertedMap["password"] != senha) {
      return null;
    }

    User foundUser = User.fromMap(convertedMap as Map<String, dynamic>);
    _loginSession = LoginSession(
      userCPF: foundUser.cpf,
      user: foundUser,
      validUntil: DateTime.now().add(const Duration(days: 1)),
    );
    loginBox ??= await Hive.openBox<LoginSession>("loginSession");
    loginBox!.put(1, _loginSession!);
    return foundUser;
  }
}
