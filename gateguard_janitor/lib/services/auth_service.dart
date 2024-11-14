import 'package:gateguard/models/login_session.dart';
import 'package:gateguard/models/roles.dart';
import 'package:gateguard/models/user.dart';
import 'package:gateguard/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository authRepository;

  AuthService({required this.authRepository});

  User? currentSession;
  Future<AuthSession?> login(
      {required String cpf, required String password}) async {
    User? user = await authRepository.findUserByCpfAndSenha(cpf, password);
    if (user == null) return null;
    if (user.role == Role.morador) {
      throw Exception("Morador não pode fazer login");
    }
    AuthSession loginSession = AuthSession(
      userCPF: user.cpf,
      user: user,
      validUntil: DateTime.now().add(const Duration(days: 1)),
    );
    currentSession = user;
    await authRepository.saveSession(loginSession);
    return loginSession;
  }

  Future<bool> checkLoginSession() async {
    final result = await authRepository.checkLoginSession();
    if (result) {
      currentSession = await authRepository.getCurrentUser();
    }
    return result;
  }

  void logout() {
    authRepository.logout();
    currentSession = null;
  }
}
