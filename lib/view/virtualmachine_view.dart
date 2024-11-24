import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/dbHelper/mongodb.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/user_service.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
import 'package:flutter_project/view/user_detail.dart';
import 'package:flutter_project/view/virtualmachine_view_create.dart';
import 'package:flutter_project/view/virtualmachine_view_detail.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';

class VirtualmachineView extends StatefulWidget {
  final UserModel event;
  const VirtualmachineView({super.key, required this.event});

  @override
  State<VirtualmachineView> createState() => _VirtualmachineViewState();
}

class _VirtualmachineViewState extends State<VirtualmachineView> {
  bool isCheckingConnection = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final eventService = VirtualmachineService();
  final userService = UserService();
  List<VirtualmachineModel> items = [];
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
    if (connectivityResult.contains(ConnectivityResult.none)) {
      loadEvents();
      setState(() {
        isCheckingConnection = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bạn đang ngoại tuyến')));
    } else {
      if (!Mongodb.db.isConnected) {
        await Mongodb.connect();
      }

      setState(() {
        isCheckingConnection = true;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đang kết nối internet')));
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
              : FutureBuilder(
                  future: Mongodb.getData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var totalData = snapshot.data.length;
                      print('Total Data' + totalData.toString());
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          final item = VirtualmachineModel.fromJson(
                              snapshot.data[index]);

                          return GestureDetector(
                            onLongPress: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) =>
                                          VirtualmachineViewDetail(
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
                                              onPressed: () async {
                                                await Mongodb.delete(item);
                                                setState(() {});
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
                      );
                    } else {
                      return const Center(child: Text('Not Found Data'));
                    }
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const VirtualmachineViewCreate()))
              .then((value) async {
            if (value == true) {
              await loadEvents();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
