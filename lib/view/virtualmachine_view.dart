import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/user_service.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
import 'package:flutter_project/view/user_detail.dart';
import 'package:flutter_project/view/virtualmachine_view_create.dart';
import 'package:flutter_project/view/virtualmachine_view_detail.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';
import 'package:http/http.dart' as http;

String getBackendUrl() {
  if (kIsWeb) {
    return 'http://localhost:8080';
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2:8080';
  } else {
    return 'http://localhost:8080';
  }
}

class VirtualmachineView extends StatefulWidget {
  final UserModel event;
  const VirtualmachineView({super.key, required this.event});

  @override
  State<VirtualmachineView> createState() => _VirtualmachineViewState();
}

class _VirtualmachineViewState extends State<VirtualmachineView> {
  bool isCheckingConnection = false;
  bool isStart = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final eventService = VirtualmachineService();
  final userService = UserService();
  List<VirtualmachineModel> items = [];
  final _todo = <VirtualmachineModel>[];
  final url = '${getBackendUrl()}/api/v1/todos';
  final urlasync = '${getBackendUrl()}/api/v1/todos/async';
  final _headers = {'Content-Type': 'application/json'};
  String username = '';
  @override
  void initState() {
    super.initState();
    _initConnection();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchTodos() async {
    final events = await eventService.getAllEvents();
    items = events;
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      if (items.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hệ thống bắt đầu đồng bộ ')));

        final resasync = await http.post(
          Uri.parse(urlasync),
          headers: _headers,
          body: json.encode(items),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Đã đồng bộ xong')));
        final List<dynamic> todoListAsync = json.decode(resasync.body);
        setState(() {
          _todo.clear();
          _todo.addAll(todoListAsync
              .map((e) => VirtualmachineModel.fromMap(e))
              .toList());
        });
      }
    }
  }

  Future<void> _deleteTodos(VirtualmachineModel data) async {
    final res = await http.delete(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(data.toMap()),
    );

    if (res.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đã xoá thành công ')));
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> todoList = json.decode(res.body);
        setState(() {
          _todo.clear();
          _todo.addAll(
              todoList.map((e) => VirtualmachineModel.fromMap(e)).toList());
        });
      }
    }
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
  }

  Future<void> _initConnection() async {
    List<ConnectivityResult> result =
        await (Connectivity().checkConnectivity());
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    try {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        loadEvents();
        setState(() {
          isCheckingConnection = false;
        });
        if (!isStart) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bạn đang ngoại tuyến')));
        }
        isStart = false;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bạn đang kết nối internet')));
        loadEvents();
        _fetchTodos();

        setState(() {
          isCheckingConnection = true;
        });
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  Future<void> loadUsername() async {
    final events = await userService.getAllUser();

    final eventofid = events.firstWhere((e) => e.id == widget.event.id);
    if (eventofid.username != widget.event.username) {
      setState(() {
        username == eventofid.username;
      });
    }
  }

  Future<void> _delteteEvents(event) async {
    await eventService.deleteEvent(event);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Bạn đã xoá thành công ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(2.0), // Chiều cao của border dưới
              child: Container(
                color: Colors.grey, // Màu của border dưới
                height: 2.0, // Độ dày của border dưới
              )),
          actions: [
            Container(
              padding: const EdgeInsets.all(0.8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(username != '' ? username : widget.event.username),
                      const Text('Admin')
                    ],
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => UserDetail(
                                    event: widget.event,
                                  )))
                          .then((value) async {
                        if (value == true) {
                          loadUsername();
                        }
                      })
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
          ]),
      body: Padding(
          padding: const EdgeInsets.all(0.8),
          child: !isCheckingConnection
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items.elementAt(index);

                    return GestureDetector(
                      onLongPress: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => VirtualmachineViewDetail(
                                      event: item,
                                    )))
                            .then((value) async {
                          if (value == true) {
                            await loadEvents();
                          }
                        });
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name),
                            Row(
                              children: [
                                Text(item.gpu),
                                const SizedBox(width: 10),
                                Text(item.cpu),
                                const SizedBox(width: 10),
                                Text(item.ram),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status:${item.status}'),
                                    const SizedBox(height: 15),
                                    Text('Price:${item.price}'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _delteteEvents(item);
                                          loadEvents();
                                        },
                                        icon: const Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      VirtualmachineViewUpdate(
                                                          event: item)))
                                              .then((value) async {
                                            if (value == true) {
                                              await loadEvents();
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.edit))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: _todo.length,
                  itemBuilder: (context, index) {
                    final item = _todo.elementAt(index);

                    return GestureDetector(
                      onLongPress: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => VirtualmachineViewDetail(
                                      event: item,
                                    )))
                            .then((value) async {
                          if (value == true) {
                            await loadEvents();
                          }
                        });
                      },
                      child: _todo.isEmpty
                          ? const CircularProgressIndicator()
                          : Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name),
                                  Row(
                                    children: [
                                      Text(item.gpu),
                                      const SizedBox(width: 10),
                                      Text(item.cpu),
                                      const SizedBox(width: 10),
                                      Text(item.ram),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Status:${item.status}'),
                                          const SizedBox(height: 15),
                                          Text('Price:${item.price}'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _delteteEvents(item);
                                                _deleteTodos(item);
                                              },
                                              icon: const Icon(Icons.delete)),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            VirtualmachineViewUpdate(
                                                                event: item)))
                                                    .then((value) async {
                                                  if (value == true) {
                                                    await loadEvents();
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.edit))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const VirtualmachineViewCreate()))
              .then((value) async {
            if (value == true) {
              if (isCheckingConnection) {
                await _fetchTodos();
                await loadEvents();
              } else {
                await loadEvents();
              }
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
