import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'firebase_options.dart';
import 'models/login_session.dart';
import 'repositories/auth_repository.dart';
import 'repositories/authorization_request_repository.dart';
import 'views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init("gateguard");
  Hive.registerAdapter(LoginSessionAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetIt.I.registerSingleton(AuthRepository());
  GetIt.I.registerSingleton(AuthorizationRequestRepository());
  runApp(MaterialApp(
    title: 'GateGuard',
    theme: ThemeData(
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E9DCC)),
      useMaterial3: true,
    ),
    home: const LoginPage(),
  ));
}
