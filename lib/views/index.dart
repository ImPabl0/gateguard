import 'package:flutter/material.dart';
import 'package:gateguard/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

import 'morador/autorizacoes_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<BottomNavigationBarItem> navigationMoradorItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.login), label: "Autorizações"),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: "Nova autorização"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Meu perfil"),
  ];

  List<BottomNavigationBarItem> navigationPorteiroItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.login), label: "Autorizações"),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: "Nova convite"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Meu perfil"),
  ];

  List<Widget> moradorWidgets = const [AutorizacoesPage()];
  List<String> moradorTitles = const [
    "Autorizações",
    "Nova autorização",
    "Meu perfil"
  ];
  int selectedPage = 0;
  Widget get selectedWidget => moradorWidgets[selectedPage];

  void changePage(int page) {
    setState(() {
      selectedPage = page;
    });
  }

  final AuthRepository authRepository = GetIt.I.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: changePage,
          backgroundColor: const Color(0xFF0E9DCC),
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color(0xFFFFE600),
          items: authRepository.loginSession!.user!.isPorteiro
              ? navigationPorteiroItems
              : navigationMoradorItems),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFF0E9DCC),
                  borderRadius: BorderRadius.circular(3)),
              child: const Text(
                "AUTORIZAÇÕES",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(child: selectedWidget)
          ],
        ),
      ),
    );
  }
}
