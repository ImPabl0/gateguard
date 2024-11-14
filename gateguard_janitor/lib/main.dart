import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gateguard/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';
import 'models/login_session.dart';
import 'repositories/auth_repository.dart';
import 'repositories/request_repository.dart';
import 'views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documentPath = await getApplicationDocumentsDirectory();
  Hive.init("${documentPath.path}\\hive");
  Hive.registerAdapter(LoginSessionAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  GetIt.I.registerSingleton(AuthRepository());
  GetIt.I.registerSingleton(AuthService(authRepository: GetIt.I.get()));
  GetIt.I.registerSingleton(RequestRepository());
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
