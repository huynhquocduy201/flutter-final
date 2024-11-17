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
    final events = await eventService.getAllUser();
    setState(() {
      items = events;
    });
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
                  backgroundImage: NetworkImage(
                      'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw8IDQ0KDgoQCA0ODw4OCAgKCg8ICQgNFREWFhURExMYHSggGBolGxMTITEhJSkuLjouFx8zODMsNygtLisBCgoKDQ0NDw0PECsZFRktKysrKysrKysrKysrLSsrKysrKzctKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIAN4A5AMBIgACEQEDEQH/xAAaAAEAAwEBAQAAAAAAAAAAAAAAAQQFAgYD/8QANhABAAECAgcGBAMJAAAAAAAAAAECEQMEBRQhMVFSoRITMkFhcRUiQlNDgZEjM2JjcrHB8PH/xAAWAQEBAQAAAAAAAAAAAAAAAAAAAQL/xAAWEQEBAQAAAAAAAAAAAAAAAAAAEQH/2gAMAwEAAhEDEQA/APeANIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH2y2Vrx52RaPOoHxLtrB0VRT4pmufPgs05TDj8OP0Sjzly70c5TDn8OFfF0ZRX4b4c9CjFH3zOSqy83mO1HND4KAAAAAAAAAAAAAAAAAAAAAIv5AsZLLTmK7fTG2pvYeHGHEUxFoh8dH4HdYcbLTO2pZZVIAAAOK6Iqi0xeJ3sLP5TuKrx4Z3PQK+cwe9omm15+mQedSTFpmOGyRpAAAAAAAAAAAAAAAAAAB3l6O3iUxv27fZws6M/fR7IPQRFosAigAAACLJAecz1HYxa4/N8V3TEWxY9Y2qSoAKAAAAAAAAAAAAAAAACzo3ZjUqzvL4nYrpn12or0wimbxCUAAAAAC4MPTE3xY9I2qT7Z2vvMSqd8XtD4qgAoAAAAAAAAAAAAAAAAIskBuaLx+9otM7adnquvN5XGnAriuN31U+Uw9BgY1ONTFVM39ODKvoFwAC4CppDG7qiZvtnZCxi4sYcXmbQwM7mJx6vSPD6gr3mUoS0gAAAAAAAAAAAAAAAAAACAS+mXzFWXm9M7PqpndL5XSg28tpGjF2T8k8J3LlOJFW6qJ/N5fspiZjzmPaZIr081xG+Yj81XH0hh4Wy/bnhG1hXnmmfeZlFv+kH3zWaqzE7dlPlHB8BK4Ai6RAAAAAAAAAAAAAAAABF0+m/hC/lNGTX81c9mOWN6CjRTNc2piavaLreFozEr32oj12tjCwKcKLU0xH930n/dqKyo0PxxP0h3Gh6fuS0wGZ8Hp+5UfB6fuVNMBmfB6fuVHwen7lTTAZnwePuT+jmdD/zOjVAYWJozEp3T2/bYq14dVG+mafeHprOMTCjEi1VMVA8ylo5vRnZ+aiL/AMMs6YtsmLT5xwVABQAAAAAAAAAAI2/4Q0NFZbtzOJVF4jwwCxo7IdiIxKovVO2In6WjZMF2VAuXAC4AFwAC4AFwAuXBEQoZ/IxixNVOyrhHm0LosDy8xaZidkxvgamlcr+LEbvFDKuqJAUAAAAAAAATh09uqKeL0WDhxhURREbmPorD7WLfg25lNVNy7m5dB1cu5uXB1cu5uXB1cu5uXB1cu5uXB1cu5uXB1cu5uXB1cu5uXAxKYriaZedx8Pu66qOD0V2Rpei1cVcYVFEBQAAAAAAABo6Hjx1NKZZ2iN1fu0JQTcu5BXQi6biAXLqFy6EIroui6AdXLuQHVy7kB1cu5AdXUNLxemmr1suqelZ/Zx/UDKAVAAAAAV9ajhJrUcJBYFfWo4Sa1HLINjRE+OGi89kM9FGJ4ZtMbWvrkcs9EFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFoVdcjlnoa5HLPQFpR0rPyRHq+muRyz0Zeks9FdXZ7M7NwOBX1qOWTWo4SosCvrUcJNajhILAr61HCQH//2Q=='),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const VirtualmachineViewDetail()),
                );
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
                                  print('xoá đã được nhấn');
                                },
                                icon: const Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const VirtualmachineViewUpdate()));
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const VirtualmachineViewCreate()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
