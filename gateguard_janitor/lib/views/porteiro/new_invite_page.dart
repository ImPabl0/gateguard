import 'package:flutter/material.dart';
import 'package:gateguard/models/invite.dart';
import 'package:gateguard/repositories/invite_repository.dart';
import 'package:gateguard/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class NewInvitePage extends StatefulWidget {
  const NewInvitePage({super.key});

  @override
  State<NewInvitePage> createState() => _NewInvitePageState();
}

class _NewInvitePageState extends State<NewInvitePage> {
  final InviteRepository inviteRepository = InviteRepositoryImpl();

  TextEditingController linkController = TextEditingController();
  AuthService authService = GetIt.I.get<AuthService>();

  @override
  void initState() {
    loadInvite();
    super.initState();
  }

  void loadInvite() async {
    Invite? invite = await inviteRepository
        .getInviteFromUser(authService.currentSession!.cpf);
    if (invite == null || invite.isExpired) {
      invite = await inviteRepository.createInvite(Invite(
        isValid: true,
        janitorCpf: authService.currentSession!.cpf,
        validUntil: DateTime.now().add(const Duration(days: 1)),
      ));
    }

    setState(() {
      linkController.text = "https://www.soupablo.com.br/invite/${invite!.id}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link de Convite:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: linkController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () {
                    // Lógica para colar o texto da área de transferência
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
