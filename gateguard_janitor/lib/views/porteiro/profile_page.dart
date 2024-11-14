import 'package:flutter/material.dart';
import 'package:gateguard/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  AuthService authService = GetIt.I.get<AuthService>();

  String get userName => authService.currentSession!.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 100.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              userName,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            InkWell(
                onTap: () {
                  authService.logout();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sair",
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ))
          ],
        ),
      ),
    );
  }
}
