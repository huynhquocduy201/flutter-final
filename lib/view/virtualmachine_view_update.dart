import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';

String getBackendUrl() {
  if (kIsWeb) {
    return 'http://localhost:8080';
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2:8080';
  } else {
    return 'http://localhost:8080';
  }
}

class VirtualmachineViewUpdate extends StatefulWidget {
  final VirtualmachineModel event;
  const VirtualmachineViewUpdate({super.key, required this.event});

  @override
  State<VirtualmachineViewUpdate> createState() =>
      _VirtualmachineViewUpdateState();
}

class _VirtualmachineViewUpdateState extends State<VirtualmachineViewUpdate> {
  bool isCheckingConnection = false;
  bool isStart = true;
  bool isConnect = false;
  String? erorr;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final _headers = {'Content-Type': 'application/json'};
  final url = '${getBackendUrl()}/api/v1/todos';
  final nameController = TextEditingController();
  final ramController = TextEditingController();
  final gpuController = TextEditingController();
  final cpuControoler = TextEditingController();
  final priceControoler = TextEditingController();
  final descriptionControoler = TextEditingController();
  final eventService = VirtualmachineService();

  String dropdownValue = 'No users';
  final urlasync = '${getBackendUrl()}/api/v1/todos/async';
  @override
  void initState() {
    super.initState();
    nameController.text = widget.event.name;
    ramController.text = widget.event.ram;
    gpuController.text = widget.event.gpu;
    cpuControoler.text = widget.event.cpu;
    priceControoler.text = widget.event.price.toString();
    descriptionControoler.text = widget.event.description;
    _initConnection();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _asyncData() async {
    List<VirtualmachineModel> items = [];
    final events = await eventService.getAllEvents();
    items = events;
    if (items.isNotEmpty) {
      if (isConnect) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Hệ thống bắt đầu đồng bộ '))));
      }

      await http.post(
        Uri.parse(urlasync),
        headers: _headers,
        body: json.encode(items),
      );
      if (isConnect) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Center(child: Text('Đã đồng bộ xong'))));
      }
    }
  }

  Future<void> _saveEvent() async {
    widget.event.name = nameController.text;
    widget.event.ram = ramController.text;
    widget.event.cpu = cpuControoler.text;
    widget.event.gpu = gpuController.text;
    widget.event.price = double.parse(priceControoler.text);
    widget.event.description = descriptionControoler.text;
    widget.event.status = dropdownValue;
    if (cpuControoler.text == '' ||
        gpuController.text == '' ||
        ramController.text == '' ||
        nameController.text == '' ||
        descriptionControoler.text == '') {
      setState(() {
        erorr = 'Please fill in all information!';
      });
    } else {
      final updatedata = VirtualmachineModel(
          id: widget.event.id,
          name: widget.event.name,
          gpu: widget.event.gpu,
          cpu: widget.event.cpu,
          ram: widget.event.ram,
          price: widget.event.price,
          description: widget.event.description,
          status: widget.event.status);
      await eventService.saveEvent(updatedata);
    }
  }

  Future<void> _updateTodos() async {
    widget.event.name = nameController.text;
    widget.event.ram = ramController.text;
    widget.event.cpu = cpuControoler.text;
    widget.event.gpu = gpuController.text;
    widget.event.price = double.parse(priceControoler.text);
    widget.event.description = descriptionControoler.text;
    widget.event.status = dropdownValue;
    if (isConnect) {
      List<VirtualmachineModel> items = [];
      final events = await eventService.getAllEvents();
      items = events;
      if (items.isNotEmpty) {
        await http.post(
          Uri.parse(urlasync),
          headers: _headers,
          body: json.encode(items),
        );
      }
    }
    if (cpuControoler.text == '' ||
        gpuController.text == '' ||
        ramController.text == '' ||
        nameController.text == '' ||
        descriptionControoler.text == '') {
      setState(() {
        erorr = 'Please fill in all information!';
      });
    } else {
      final res = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: json.encode(widget.event.toMap()),
      );
      if (res.statusCode == 200) {
        if (isConnect) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Bạn đã cập nhật thành công'))));
        }
      }
    }
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
        setState(() {
          isCheckingConnection = false;
        });
        if (!isStart) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Bạn đang ngoại tuyến'))));
        }
        isStart = false;
        isConnect = true;
      } else {
        if (isConnect) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Bạn đã kết nối internet'))));
        }

        _asyncData();
        setState(() {
          isCheckingConnection = true;
        });
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  void _resetEroor() {
    setState(() {
      erorr = null;
    });
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
        title: const Center(child: Text('Update')),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name Vitual Machine'),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), errorText: erorr),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                const SizedBox(height: 10),
                const Text('Ram'),
                TextField(
                  controller: ramController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), errorText: erorr),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                const SizedBox(height: 10),
                const Text('Gpu'),
                TextField(
                  controller: gpuController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), errorText: erorr),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                const SizedBox(height: 10),
                const Text('Cpu'),
                TextField(
                  controller: cpuControoler,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), errorText: erorr),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                const SizedBox(height: 10),
                const Text('Price'),
                TextField(
                  controller: priceControoler,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), errorText: erorr),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                const Text('description'),
                TextField(
                  keyboardType: TextInputType.multiline,
                  controller: descriptionControoler,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: erorr,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0)),
                  onChanged: (text) {
                    _resetEroor();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.menu),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        _resetEroor();
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'No users',
                          child: Text('No users'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'There are users',
                          child: Text('There are users'),
                        ),
                      ],
                    ),
                    FilledButton.icon(
                      onPressed: isCheckingConnection
                          ? () {
                              _saveEvent();
                              _updateTodos();
                              Navigator.of(context).pop(true);
                            }
                          : () {
                              _saveEvent();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Center(
                                          child: Text(
                                              'Bạn đã cập nhật thành công'))));
                              Navigator.of(context).pop(true);
                            },
                      label: const Text('Update sự kiện'),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
