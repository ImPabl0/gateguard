import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gateguard/models/request_model.dart';
import 'package:gateguard/models/notification.dart';

class RequestRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ValueChanged<List<Request>>? _onChangedRequests;

  void listenToRequests(ValueChanged<List<Request>> onChanged) {
    _onChangedRequests = onChanged;
    firestore
        .collection("requests")
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((event) async {
      final requests = await _parseRequests(event.docs);
      _onChangedRequests!(requests);
    });
  }

  Future<void> createAuthorizationRequest(Map<String, dynamic> data) async {
    CollectionReference<Map<String, dynamic>> authorizations =
        firestore.collection("requests");
    await authorizations.add(data);
  }

  Future<void> createNotificationToUser(NotificationModel notification) async {
    CollectionReference<Map<String, dynamic>> authorizations =
        firestore.collection("notifications");
    final user =
        await firestore.collection("users").doc(notification.user.cpf).get();
    Map<String, dynamic> notificationData = notification.toMap();
    notificationData["user"] = user.reference;
    await authorizations.add(notificationData);
  }

  Future<List<Request>> getAuthorizationRequests() async {
    final requests = await firestore.collection("requests").get();

    return requests.docs.map((e) {
      final request = e.data();
      request["id"] = e.id;
      return Request.fromMap(request);
    }).toList();
  }

  Future<List<Request>> findAllRequests() async {
    final requests = await firestore
        .collection("requests")
        .orderBy("created_at", descending: false)
        .get();

    return await _parseRequests(requests.docs);
  }

  Future<List<Request>> findRequestsByCpf(String userCPF) async {
    final requester = await firestore
        .collection("users")
        .where("__name__", isEqualTo: userCPF)
        .get();

    if (requester.docs.isEmpty) {
      return [];
    }

    final requests = await firestore
        .collection("requests")
        .where("requester", isEqualTo: requester.docs.first.reference)
        .get();

    return await _parseRequests(requests.docs);
  }

  Future<void> denyRequest(Request request) async {
    await firestore.collection("requests").doc(request.id).get().then((value) {
      value.reference.update({"status": "DENIED"});
    });
    NotificationModel notification = NotificationModel(
        title: "Solicitação Negada",
        message: "A entrada para ${request.guestName} foi negada agora.",
        user: request.requester!,
        createdAt: Timestamp.now(),
        read: false);
    await createNotificationToUser(notification);
  }

  Future<void> approveRequest(Request request) async {
    await firestore.collection("requests").doc(request.id).get().then((value) {
      value.reference.update({"status": "APPROVED"});
    });
    NotificationModel notification = NotificationModel(
        title: "Solicitação Aprovada",
        message: "A entrada para ${request.guestName} foi aprovada agora.",
        user: request.requester!,
        createdAt: Timestamp.now(),
        read: false);
    await createNotificationToUser(notification);
  }

  Future<List<Request>> _parseRequests(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> requests) async {
    List<Map<String, dynamic>> docs = requests.map((e) {
      final request = e.data();
      request["id"] = e.id;
      return request;
    }).toList();

    for (var doc in docs) {
      final documentSnapshot =
          (await (doc["requester"] as DocumentReference<Map<String, dynamic>>)
              .get());
      doc["requester"] = documentSnapshot.data();
      doc["requester"]["cpf"] = documentSnapshot.id;
    }
    return docs.map((e) => Request.fromMap(e)).toList();
  }
}
