import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
import 'package:flutter_project/view/virtualmachine_view_create.dart';
import 'package:flutter_project/view/virtualmachine_view_detail.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';

class VirtualmachineView extends StatefulWidget {
  const VirtualmachineView({super.key});

  @override
  State<VirtualmachineView> createState() => _VirtualmachineViewState();
}

class _VirtualmachineViewState extends State<VirtualmachineView> {
  final eventService = VirtualmachineService();
  List<VirtualmachineModel> items = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
  }

  Future<void> _delteteEvents(event) async {
    await eventService.deleteEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(0.8),
          child: Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Text('Dan1512003'),
                  Text('Admin')
                ],
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => {print('ok')},
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
        child: ListView.builder(
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
        ),
      ),
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
