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
  bool isStart = false;
  bool isConnect = false;
  bool isasync =true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final eventService = VirtualmachineService();
  final userService = UserService();
  List<VirtualmachineModel> items = [];
  final _todo = <VirtualmachineModel>[];
  final url = '${getBackendUrl()}/api/v1/todos';
  final urlasync = '${getBackendUrl()}/api/v1/todos/async';
  final urlfilter = '${getBackendUrl()}/api/v1/todos/filterdata';
  final _headers = {'Content-Type': 'application/json'};
  String username = '';
  String? dropdownValue;
  String? dropdownValueSort;
  String? erorr;
  @override
  void initState() {
    super.initState();
    

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
        _initConnection();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

//Hàm sắp xếp theo giá thuê  máy
  Future<void> _sortData() async {
    final events = await eventService.getAllEvents();
    if (dropdownValueSort == 'decrease') {
      items = events;
      int n = items.length;
      for (int i = 0; i < n - 1; i++) {
        int maxValue = i;
        for (int j = i + 1; j < n; j++) {
          if (items[j].price > items[maxValue].price) {
            maxValue = j;
          }
        }
        if (maxValue != i) {
          VirtualmachineModel temp = items[i];
          items[i] = items[maxValue];
          items[maxValue] = temp;
        }
      }
      setState(() {
        items;
      });
    }
    if (dropdownValueSort == 'increase') {
      items = events;
      int n = items.length;
      for (int i = 0; i < n - 1; i++) {
        int minValue = i;
        for (int j = i + 1; j < n; j++) {
          if (items[j].price < items[minValue].price) {
            minValue = j;
          }
        }
        if (minValue != i) {
          VirtualmachineModel temp = items[i];
          items[i] = items[minValue];
          items[minValue] = temp;
        }
      }
      setState(() {
        items;
      });
    }
  }

  Future<void> _sortTodo() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
     
        final List<dynamic> todoListAsync = json.decode(res.body);
 if (todoListAsync.isNotEmpty) {
        _todo.clear();
        _todo.addAll(
            todoListAsync.map((e) => VirtualmachineModel.fromMap(e)).toList());
        if (dropdownValueSort == 'decrease') {
          int n = _todo.length;
          for (int i = 0; i < n - 1; i++) {
            int maxValue = i;
            for (int j = i + 1; j < n; j++) {
              if (_todo[j].price > _todo[maxValue].price) {
                maxValue = j;
              }
            }
            if (maxValue != i) {
              VirtualmachineModel temp = _todo[i];
              _todo[i] = _todo[maxValue];
              _todo[maxValue] = temp;
            }
          }
          setState(() {
            _todo;
          });
        }
        if (dropdownValueSort == 'increase') {
          int n = _todo.length;
          for (int i = 0; i < n - 1; i++) {
            int minValue = i;
            for (int j = i + 1; j < n; j++) {
              if (_todo[j].price < _todo[minValue].price) {
                minValue = j;
              }
            }
            if (minValue != i) {
              VirtualmachineModel temp = _todo[i];
              _todo[i] = _todo[minValue];
              _todo[minValue] = temp;
            }
          }
          setState(() {
            _todo;
          });
        }
      }
    }
  }

  Future<void> _filterDoto() async {
    final res = await http.post(
      Uri.parse(urlfilter),
      headers: _headers,
      body: json.encode({'status': dropdownValue}),
    );

    final List<dynamic> todoListAsync = json.decode(res.body);
    setState(() {
      _todo.clear();
      _todo.addAll(
          todoListAsync.map((e) => VirtualmachineModel.fromMap(e)).toList());
    });
  }

//Hàm lọc những máy không có người thuê

  Future<void> _filterData() async {
    final events = await eventService.getAllEvents();
    if (dropdownValue == 'No users') {
      items.clear();

      Iterable<VirtualmachineModel?> data = events.map((item) {
        if (item.status == 'No users') {
          return item;
        }
        return null;
      });
      List<VirtualmachineModel> listData = data
          .where((item) => item != null)
          .cast<VirtualmachineModel>()
          .toList();
      setState(() {
        items = listData;
      });
    }
    if (dropdownValue == 'There are users') {
      items.clear();

      Iterable<VirtualmachineModel?> data = events.map((item) {
        if (item.status == 'There are users') {
          return item;
        }
        return null;
      });
      List<VirtualmachineModel> listData = data
          .where((item) => item != null)
          .cast<VirtualmachineModel>()
          .toList();
      setState(() {
        items = listData;
      });
    }
    if (dropdownValue == 'All') {
      setState(() {
        items = events;
      });
    }
  }
Future<void> _asyncData() async {
    try{
       final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
        List<VirtualmachineModel> listitems = [];
    listitems = events;

    if (listitems.isNotEmpty) {
      if (isConnect) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('The system is synchronizing...'))));
      }

    final resasync=  await http.post(
        Uri.parse(urlasync),
        headers: _headers,
        body: json.encode(listitems),
      );
      if (resasync.statusCode == 200) {
      if (isConnect) {
   if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content:Center(child:Text('Synchronization completed')) ));
 
      }
      final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
        final List<dynamic> todoList = json.decode(res.body);
      
  setState(() {
          erorr=null;
          _todo.clear();
          _todo.addAll(todoList
              .map((e) => VirtualmachineModel.fromMap(e))
              .toList());
              isasync=false;
        });
       
      
      
    }
      }

    }else{
setState(() {
         erorr='No data found';
          isasync=false;
      });
    }
    } catch(e){ 
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content:Center(child:Text('Sync error:${e.toString()}')) ));
      
      }
  
  }
  Future<void> _fetchTodos() async {
   
   
  
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
        final List<dynamic> todoList = json.decode(res.body);
        if(todoList.isNotEmpty){
 setState(() {
  erorr=null;
          _todo.clear();
          _todo.addAll(todoList
              .map((e) => VirtualmachineModel.fromMap(e))
              .toList());
        });
        }else{
          setState(() {
         erorr='No data found';
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('You have successfully deleted'))));
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final List<dynamic> todoList = json.decode(res.body);
        if(todoList.isNotEmpty){
  setState(() {

          _todo.clear();
          _todo.addAll(
              todoList.map((e) => VirtualmachineModel.fromMap(e)).toList());
        });
        }else{
          setState(() {
        isasync=false;
         erorr='No data found';
      });
        }
      
      }
    }
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();
    if(events.isNotEmpty){
 setState(() {
  
      erorr=null;
  

      items = events;
      isasync=false;
    });
    }else{
      setState(() {
        isasync=false;
         erorr='No data found';
      });
     
    }
   
  }

  Future<void> _initConnection() async {
    List<ConnectivityResult> result =
        await (Connectivity().checkConnectivity());
        isStart=true;
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
        setState(() {
          isasync=true;
        });
    try {
      
      if (connectivityResult.contains(ConnectivityResult.none)) {
       await loadEvents();
        setState(() {
          isCheckingConnection = false;
        });
        if (!isStart) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('You are offline'))));
        }
        isStart = false;
        isConnect = true;
      } else {
       
        if (isConnect) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('You are online'))));
        }
     if(isStart){
      setState(() {
        isStart=false;
        if(kIsWeb){
_asyncData();
        }
        
      });
     }else{
  _asyncData();
       
        
     }
     
      
     
        

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
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(0.8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Text(username != ''
                              ? username
                              : widget.event.username),
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
              ],
            )
          ]),
      body: isasync? const Center(child: CircularProgressIndicator()):Padding(
          padding: const EdgeInsets.all(0.8),
          child: erorr!=null ? Center(child: Text('$erorr'),): Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  hint: const Text('Filter by Status'),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                    isCheckingConnection ? _filterDoto() : _filterData();
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'No users',
                      child: Text('No users'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'All',
                      child: Text('All'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'There are users',
                      child: Text('There are users'),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                DropdownButton<String>(
                  value: dropdownValueSort,
                  hint: const Text('Sort by price'),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueSort = newValue!;
                    });
                    isCheckingConnection ? _sortTodo() : _sortData();
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'increase',
                      child: Text('increase'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'decrease',
                      child: Text('decrease'),
                    ),
                  ],
                ),
              ]),
              Expanded(
                  child: !isCheckingConnection
                      ? ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items.elementAt(index);

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
                                        Text('GPU:${item.gpu}'),
                                        const SizedBox(width: 10),
                                        Text('CPU:${item.cpu}'),
                                        const SizedBox(width: 10),
                                        Text('RAM:${item.ram}'),
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
                                            Text('Price:${item.price}/h'),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                        builder: (context) =>
                                            VirtualmachineViewDetail(
                                              event: item,
                                            )))
                                    .then((value) async {
                                  if (value == true) {
                                    await loadEvents();
                                    await _fetchTodos();
                                  }
                                });
                              },
                              child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name),
                                          Row(
                                            children: [
                                               Text('GPU:${item.gpu}'),
                                        const SizedBox(width: 10),
                                        Text('CPU:${item.cpu}'),
                                        const SizedBox(width: 10),
                                        Text('RAM:${item.ram}'),
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
                                                  Text('Price:${item.price}/h'),
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
                                                      icon: const Icon(
                                                          Icons.delete)),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                                builder: (context) =>
                                                                    VirtualmachineViewUpdate(
                                                                        event:
                                                                            item)))
                                                            .then(
                                                                (value) async {
                                                          if (value == true) {
                                                            await loadEvents();
                                                          }
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                            );
                          },
                        ))
            ],
          )),
      floatingActionButton:isasync?null: FloatingActionButton(
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
        child:  const Icon(Icons.add),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.endFloat,
    );
  }
}
