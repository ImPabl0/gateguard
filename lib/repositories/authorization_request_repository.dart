import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:gateguard/models/authorization.dart';

class AuthorizationRequestRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> createAuthorizationRequest(Map<String, dynamic> data) async {
    DatabaseReference authorizationRequestRef =
        _database.ref("authorization_requests");
    await authorizationRequestRef.set(data);
  }

  Future<List<Authorization>> getAuthorizationRequests() async {
    DatabaseReference authorizationRequestRef =
        _database.ref("authorization_requests");
    DatabaseEvent snapshot = await authorizationRequestRef.once();
    if (snapshot.snapshot.value == null) {
      return [];
    }
    List<Object?> authorizationRequests =
        snapshot.snapshot.value as List<Object?>;
    List<Authorization> convertedList = [];
    for (Object? authorizationRequest in authorizationRequests) {
      LinkedHashMap map = authorizationRequest as LinkedHashMap;
      Map<String, dynamic> convertedMap = map.cast<String, dynamic>();
      convertedList.add(Authorization.fromMap(convertedMap));
    }
    return convertedList;
  }

  Future<List<Authorization>> findAuthorizationByUser(String userCPF) async {
    DatabaseReference authorizationRequestRef =
        _database.ref("authorization_requests");
    DatabaseEvent snapshot = await authorizationRequestRef
        .orderByChild("requester/cpf")
        .equalTo(userCPF)
        .once();
    if (snapshot.snapshot.value == null) {
      return [];
    }
    List<Object?> authorizationRequests =
        snapshot.snapshot.value as List<Object?>;
    List<Authorization> convertedList = [];
    for (Object? authorizationRequest in authorizationRequests) {
      LinkedHashMap<Object?, Object?> map =
          authorizationRequest as LinkedHashMap<Object?, Object?>;
      Map<String, dynamic> convertedMap = map.cast();
      convertedList.add(Authorization.fromMap(convertedMap));
    }
    return convertedList;
  }
}
