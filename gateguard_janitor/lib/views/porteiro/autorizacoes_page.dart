import 'package:flutter/material.dart';
import 'package:gateguard/models/request_model.dart';
import 'package:gateguard/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

import '../../repositories/request_repository.dart';

class AutorizacoesPage extends StatefulWidget {
  const AutorizacoesPage({super.key});

  @override
  State<AutorizacoesPage> createState() => _AutorizacoesPageState();
}

class _AutorizacoesPageState extends State<AutorizacoesPage> {
  RequestRepository authorizationRequestRepository = GetIt.I.get();
  AuthRepository authRepository = GetIt.I.get();
  @override
  void initState() {
    // getAuthorizations();
    authorizationRequestRepository.listenToRequests((requests) {
      if (!mounted) return;
      setState(() {
        this.requests = requests;
      });
    });
    super.initState();
  }

  Future<void> getAuthorizations() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      List<Request> requests =
          await authorizationRequestRepository.findAllRequests();
      setState(() {
        this.requests = requests;
      });
    } catch (e, stack) {
      debugPrint("$e\n$stack");
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isLoading = false;
  String error = "";
  List<Request> requests = [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (requests.isEmpty) {
      return const Center(
        child: Text("Nenhuma solicitação encontrada"),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        itemCount: requests.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return RequestCard(currRequest: requests[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}

class RequestCard extends StatefulWidget {
  final Request currRequest;
  const RequestCard({required this.currRequest, super.key});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  RequestRepository requestRepository = GetIt.I.get();
  Color getColorByStatus(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.PENDING:
        return const Color(0xFFE6CF00);
      case AuthorizationStatus.ACCEPTED:
        return Colors.green;
      case AuthorizationStatus.DENIED:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  IconData getIconByType(AuthorizationType type) {
    switch (type) {
      case AuthorizationType.PERSON:
        return Icons.person;
      case AuthorizationType.VEHICLE:
        return Icons.directions_car;
      default:
        return Icons.error;
    }
  }

  bool showingDetails = false;
  bool get canChangeStatus =>
      widget.currRequest.status == AuthorizationStatus.PENDING;
  Request get request => widget.currRequest;

  void showDetails() {
    setState(() {
      showingDetails = !showingDetails;
    });
  }

  void acceptRequest() async {
    try {
      await requestRepository.approveRequest(request);
      setState(() {
        widget.currRequest.status = AuthorizationStatus.ACCEPTED;
      });
    } catch (e, stack) {
      debugPrint("$e\n$stack");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro ao aceitar solicitação: $e")),
      );
    }
  }

  void denyRequest() async {
    bool confirmDeny = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Recusa"),
          content: const Text(
              "Você tem certeza que deseja recusar esta solicitação?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Recusar"),
            ),
          ],
        );
      },
    );

    if (confirmDeny) {
      try {
        await requestRepository.denyRequest(request);
        setState(() {
          widget.currRequest.status = AuthorizationStatus.DENIED;
        });
      } catch (e, stack) {
        debugPrint("$e\n$stack");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Erro ao recusar solicitação: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDetails,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: getColorByStatus(widget.currRequest.status),
              borderRadius: showingDetails
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(5), topRight: Radius.circular(5))
                  : BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    getIconByType(widget.currRequest.type),
                    color: Colors.white,
                    size: 40,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.currRequest.requester!.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "Entrada requisitada às ${widget.currRequest.createdAt.hour}:${widget.currRequest.createdAt.minute}",
                            style: const TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: showingDetails ? 0 : -90 / 360,
                    duration: Durations.short2,
                    curve: Curves.decelerate,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedContainer(
            width: double.infinity,
            duration: Durations.short2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 0.5,
                  )
                ]),
            curve: Curves.decelerate,
            child: Visibility(
              visible: showingDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.start,
                      widget.currRequest.description,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Visibility(
                    visible: canChangeStatus,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: acceptRequest,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Aceitar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: denyRequest,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Recusar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
