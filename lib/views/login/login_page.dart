import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gateguard/common/default_input_decoration.dart';
import 'package:gateguard/common/label_wrapper.dart';
import 'package:gateguard/models/user.dart';
import 'package:gateguard/repositories/auth_repository.dart';
import 'package:gateguard/views/index.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthRepository authRepository = GetIt.I.get();

  Future<void> login() async {
    String cpf = UtilBrasilFields.removeCaracteres(cpfController.text);
    String senha = senhaController.text;
    User? foundUser = await authRepository.findUserByCpfAndSenha(cpf, senha);
    if (foundUser == null) {
      return;
    }
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const IndexPage()));
  }

  void forgotPassword() {}

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  Future<void> checkIfLoggedIn() async {
    if (await authRepository.checkLoginSession()) {
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const IndexPage()));
    }
  }

  final TextEditingController cpfController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                child: SvgPicture.asset("assets/svgs/bottomwave.svg")),
            Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset("assets/svgs/topwave.svg")),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                        color: Colors.black.withOpacity(0.3))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 200,
                    child: LabelWrapper(
                      text: Text(
                        "CPF",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.75)),
                      ),
                      child: TextFormField(
                        controller: cpfController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        validator: (value) {
                          bool cpfValido = false;
                          try {
                            cpfValido = UtilBrasilFields.isCPFValido(value);
                          } catch (e) {
                            return "CPF inválido";
                          }
                          if (value!.isEmpty || !cpfValido) {
                            return "CPF inválido";
                          }

                          return null;
                        },
                        decoration: defaultInputDecoration,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: LabelWrapper(
                      text: Text(
                        "SENHA",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.75)),
                      ),
                      child: TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: defaultInputDecoration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: const Color(0xFF9BE7FF),
                    borderRadius: BorderRadius.circular(3),
                    child: InkWell(
                      onTap: login,
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(),
                        child: const Text(
                          "ENTRAR",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: forgotPassword,
                      child: const Text("Esqueceu a senha?")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
