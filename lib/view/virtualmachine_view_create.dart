import 'package:flutter/material.dart';
import 'package:flutter_project/dbHelper/mongodb.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';

class VirtualmachineViewCreate extends StatefulWidget {
  const VirtualmachineViewCreate({super.key});

  @override
  State<VirtualmachineViewCreate> createState() =>
      _VirtualmachineViewCreateState();
}

class _VirtualmachineViewCreateState extends State<VirtualmachineViewCreate> {
  final nameController = TextEditingController();
  final ramController = TextEditingController();
  final gpuController = TextEditingController();
  final cpuControoler = TextEditingController();
  final priceControoler = TextEditingController();
  final descriptionControoler = TextEditingController();
  final eventService = VirtualmachineService();
  final event = VirtualmachineModel(
      id: '',
      name: '',
      gpu: '',
      cpu: '',
      ram: '',
      price: 0,
      description: '',
      status: '');
  String dropdownValue = 'No users';

  Future<void> _addEvent() async {
    double? result = double.tryParse(priceControoler.text);
    if (result == null) {}
    event.cpu = cpuControoler.text;
    event.gpu = gpuController.text;
    event.price = double.tryParse(priceControoler.text);
    event.ram = ramController.text;
    event.description = descriptionControoler.text;
    event.name = nameController.text;
    event.status = dropdownValue;
    await eventService.saveEvent(event);
    var messenger = await Mongodb.insert(event);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(messenger)));
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
        title: const Center(child: Text('Add Item Virtual Machine')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name Vitual Machine'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Ram'),
            TextField(
              controller: ramController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            const Text('Gpu'),
            TextField(
              controller: gpuController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            const Text('Cpu'),
            TextField(
              controller: cpuControoler,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            const Text('Price'),
            TextField(
              controller: priceControoler,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const Text('description'),
            TextField(
              controller: descriptionControoler,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0)),
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
                FilledButton.tonalIcon(
                  onPressed: () {
                    _addEvent();
                    Navigator.of(context).pop(true);
                  },
                  label: const Text('Create'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
