import 'package:flutter/material.dart';
import 'package:gateguard/models/authorization.dart';
import 'package:gateguard/models/roles.dart';
import 'package:gateguard/models/user.dart';
import 'package:gateguard/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

import '../../repositories/authorization_request_repository.dart';

class AutorizacoesPage extends StatefulWidget {
  const AutorizacoesPage({super.key});

  @override
  State<AutorizacoesPage> createState() => _AutorizacoesPageState();
}

class _AutorizacoesPageState extends State<AutorizacoesPage> {
  AuthorizationRequestRepository authorizationRequestRepository = GetIt.I.get();
  AuthRepository authRepository = GetIt.I.get();
  @override
  void initState() {
    getAuthorizations();
    super.initState();
  }

  void getAuthorizations() async {
    List<Authorization> authorizations = await authorizationRequestRepository
        .findAuthorizationByUser(authRepository.loginSession!.user!.cpf);
    setState(() {
      this.authorizations = authorizations;
    });
    print("Recebido!");
  }

  List<Authorization> authorizations = [];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: authorizations.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}
