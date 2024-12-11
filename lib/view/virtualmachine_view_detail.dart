import 'dart:async';
import 'dart:convert';
import 'dart:io';


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
 String? messageErorr;
 
  final eventService = VirtualmachineService();
  bool isCheckingConnection = false;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final _headers = {'Content-Type': 'application/json'};
  final url = '${getBackendUrl()}/api/v1/todos';
  final urlasync = '${getBackendUrl()}/api/v1/todos/finddata';
  final urlfind = '${getBackendUrl()}/api/v1/todos/findId';
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
    
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    
     
      if (connectivityResult.contains(ConnectivityResult.none)) {
        setState(() {
          loadEvents();
        });
        
      } else {
        setState(() {
          loadEventsTodo();
        });
        
      }
    
  }

  Future<void> _initConnection() async {
    try{List<ConnectivityResult>
     result =
        await (Connectivity().checkConnectivity());
    return _updateConnectionStatus(result);} catch(e){
      messageErorr='Connection error :$e';
    }
    
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
   
      if (connectivityResult.contains(ConnectivityResult.none)) {
        loadEvents();
        setState(() {
          isCheckingConnection = false;
        });
        
      } else {
        

        loadEventsTodo();
        loadEvents();
        setState(() {
          isCheckingConnection = true;
        });
      }
    
  }

  Future<void> delteteEvents() async {
    try{
      await eventService.deleteEvent(widget.event);
    }catch(e){
        setState(() {
        messageErorr='Error:${e.toString()}';
      });
    }
    
  }

  Future<void> _deleteTodos() async {
    try{
          final res = await http.delete(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(widget.event.toMap()),
    );

    if (res.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('you have successfully deleted '))));
    }
    }catch(e){
       setState(() {
        messageErorr='Error:${e.toString()}';
      });
    }

  }

  Future<void> loadEvents() async {
    try {
        final events = await eventService.getAllEvents();

    final eventofid = events.firstWhere((e) => e.id == widget.event.id);
  
     setState(() {
      widget.event == eventofid;
    });
    }catch(e){
       setState(() {
        messageErorr='Error:${e.toString()}';
      });
    }
  
  }

 

  Future<void> loadEventsTodo() async {
    try{  
    final res = await http.post(
      Uri.parse(urlfind),
      headers: _headers,
      body: json.encode(widget.event.toMap()),
    );

    if (res.statusCode == 200) {
      final todoList = json.decode(res.body);
      Map<String, dynamic> mapData = todoList as Map<String, dynamic>;
      setState(() {
        widget.event == VirtualmachineModel.fromMap(mapData);
      });
    }}catch(e){
    setState(() {
        messageErorr='Error:${e.toString()}';
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
        child: messageErorr!=null?Row(mainAxisAlignment:MainAxisAlignment.center , 
        children: [Text('$messageErorr')],): Column(
          children: [
   Card(child:Column(children: [         Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('GPU:${widget.event.gpu}'),
                const SizedBox(width: 10),
                Text('CPU:${widget.event.cpu}'),
                const SizedBox(width: 10),
                Text('RAM:${widget.event.ram}'),
              ],
            ),
            const SizedBox(height: 15),
            const Row( mainAxisAlignment :MainAxisAlignment.start,children: [  Text('Description:'),],),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Column( children: [
              
                 const SizedBox(height: 10),
                Text(widget.event.description)],)],
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Price:${widget.event.price}/h '),
              Text('Status:${widget.event.status}'),
            ]),
            const SizedBox(height: 15),
               Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(widget.event.status == 'No users'
                        ? 'The device has no users'
                        : 'The device is currently occupied')
              ],
            )
              ,],) ,),
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
                              delteteEvents();
                              _deleteTodos();

                              Navigator.of(context).pop(true);
                            }
                          : () {
                              delteteEvents();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Center(
                                          child:
                                              Text('You have successfully deleted '))));
                              Navigator.of(context).pop(true);
                            },
                      label: const Text('Delete'),
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
                      label: const Text('Update'),
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
