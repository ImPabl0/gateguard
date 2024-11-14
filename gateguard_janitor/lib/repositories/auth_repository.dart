import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gateguard/models/login_session.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';

class AuthRepository {
  AuthSession? _loginSession;
  Box<AuthSession>? loginBox;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthSession? get loginSession => _loginSession?.copyWith();

  Future<void> _loadLoginSession() async {
    loginBox ??= await Hive.openBox<AuthSession>("loginSession");
    _loginSession = loginBox!.get(1);
  }

  Future<void> logout() async {
    loginBox ??= await Hive.openBox<AuthSession>("loginSession");
    loginBox!.delete(1);
  }

  Future<void> saveSession(AuthSession session) async {
    loginBox ??= await Hive.openBox<AuthSession>("loginSession");
    await loginBox!.put(1, session);
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

  Future<User?> getCurrentUser() async {
    await _loadLoginSession();
    if (_loginSession == null) {
      return null;
    }
    User? foundUser = await findUserByCpf(_loginSession!.userCPF);
    if (foundUser == null) {
      return null;
    }
    _loginSession!.user = foundUser;
    return foundUser;
  }

  Future<User?> findUserByCpf(String cpf) async {
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection("users")
        .where("__name__", isEqualTo: cpf)
        .get();
    if (result.docs.isEmpty) {
      return null;
    }
    User foundUser = User.fromMap(result.docs[0].data());
    foundUser.cpf = result.docs[0].id;
    return foundUser;
  }

  Future<User?> findUserByCpfAndSenha(String cpf, String senha) async {
    QuerySnapshot<Map<String, dynamic>> result = await firestore
        .collection("users")
        .where("__name__", isEqualTo: cpf)
        .where("password", isEqualTo: senha)
        .get();
    if (result.docs.isEmpty) {
      return null;
    }
    User foundUser = User.fromMap(result.docs[0].data());
    foundUser.cpf = result.docs[0].id;
    _loginSession = AuthSession(
      userCPF: foundUser.cpf,
      user: foundUser,
      validUntil: DateTime.now().add(const Duration(days: 1)),
    );
    return foundUser;
  }
}
