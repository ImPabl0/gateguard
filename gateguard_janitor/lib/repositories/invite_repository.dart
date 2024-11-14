import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gateguard/models/invite.dart';

abstract class InviteRepository {
  Future<Invite?> getInviteFromUser(String cpf);
  Future<Invite?> createInvite(Invite invite);
}

class InviteRepositoryImpl implements InviteRepository {
  @override
  Future<Invite?> getInviteFromUser(String cpf) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot document =
        await firestore.collection('invites').doc(cpf).get();
    if (document.exists) {
      final data = document.data() as Map<String, dynamic>;
      data['id'] = document.id;
      return Invite.fromMap(data);
    } else {
      return null;
    }
  }

  @override
  Future<Invite?> createInvite(Invite invite) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final result = await firestore.collection('invites').add(invite.toMap());
    final snapshot = await result.get();
    invite.id = snapshot.id;
    return invite;
  }
}
