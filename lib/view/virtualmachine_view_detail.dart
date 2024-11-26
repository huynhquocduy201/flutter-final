import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
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

class VirtualmachineViewDetail extends StatefulWidget {
  final VirtualmachineModel event;
  const VirtualmachineViewDetail({super.key, required this.event});

  @override
  State<VirtualmachineViewDetail> createState() =>
      _VirtualmachineViewDetailState();
}

class _VirtualmachineViewDetailState extends State<VirtualmachineViewDetail> {
  final eventService = VirtualmachineService();
  bool isCheckingConnection = false;
  bool isStart = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final _headers = {'Content-Type': 'application/json'};
  final url = '${getBackendUrl()}/api/v1/todos';
  final urlasync = '${getBackendUrl()}/api/v1/todos/finddata';
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

  Future<void> _saveEvent() async {
    if (!mounted) return;
    Navigator.of(context).pop(true);
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
        loadEventsTodo();

        setState(() {
          isCheckingConnection = true;
        });
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  Future<void> delteteEvents() async {
    await eventService.deleteEvent(widget.event);
  }

  Future<void> _deleteTodos() async {
    final res = await http.delete(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(widget.event.toMap()),
    );

    if (res.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đã xoá thành công ')));
    }
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();

    final eventofid = events.firstWhere((e) => e.id == widget.event.id);
    setState(() {
      widget.event == eventofid;
    });
  }

  Future<void> _asyncData() async {
    List<VirtualmachineModel> items = [];
    final events = await eventService.getAllEvents();
    items = events;
    if(items.isNotEmpty){
  if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hệ thống bắt đầu đồng bộ ')));

    await http.post(
      Uri.parse(urlasync),
      headers: _headers,
      body: json.encode(items),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Đã đồng bộ xong')));
    }
  
  }

  Future<void> loadEventsTodo() async {
    _asyncData();
    final res = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(widget.event.toMap()),
    );

    if (res.statusCode == 200) {
      final todoList = json.decode(res.body);
      Map<String, dynamic> mapData = todoList as Map<String, dynamic>;
      setState(() {
        widget.event == VirtualmachineModel.fromMap(mapData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Stack(
          children: [
            AnimatedPositioned(
              top: 15,
              left: -6,
              duration: const Duration(seconds: 0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    applyTextScaling: false,
                  )),
            )
          ],
        ),
        title: Center(child: Text(widget.event.name)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.event.gpu),
                const SizedBox(width: 10),
                Text(widget.event.cpu),
                const SizedBox(width: 10),
                Text(widget.event.ram),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [Text(widget.event.description)],
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Price:${widget.event.price} '),
              Text('Status:${widget.event.status}'),
            ]),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(widget.event.status == 'No users'
                        ? ''
                        : 'The device is currently occupied, please choose another device'))
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: isCheckingConnection
                          ? () {
                              _deleteTodos();
                              delteteEvents();
                              Navigator.of(context).pop(true);
                            }
                          : () {
                              delteteEvents();
                              Navigator.of(context).pop(true);
                            },
                      label: const Text('Xoá sự kiện'),
                    )
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => VirtualmachineViewUpdate(
                                    event: widget.event)))
                            .then((value) async {
                          if (value == true) {
                            _saveEvent();
                          }
                        });
                      },
                      label: const Text('Lưu sự kiện'),
                    )
                  ],
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
