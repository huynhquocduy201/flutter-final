import 'package:flutter/material.dart';
import 'package:flutter_project/dbHelper/mongodb.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';

class VirtualmachineViewUpdate extends StatefulWidget {
  final VirtualmachineModel event;
  const VirtualmachineViewUpdate({super.key, required this.event});

  @override
  State<VirtualmachineViewUpdate> createState() =>
      _VirtualmachineViewUpdateState();
}

class _VirtualmachineViewUpdateState extends State<VirtualmachineViewUpdate> {
  final nameController = TextEditingController();
  final ramController = TextEditingController();
  final gpuController = TextEditingController();
  final cpuControoler = TextEditingController();
  final priceControoler = TextEditingController();
  final descriptionControoler = TextEditingController();
  final eventService = VirtualmachineService();
  String dropdownValue = 'No users';
  @override
  void initState() {
    super.initState();
    nameController.text = widget.event.name;
    ramController.text = widget.event.ram;
    gpuController.text = widget.event.gpu;
    cpuControoler.text = widget.event.cpu;
    priceControoler.text = widget.event.price.toString();
    descriptionControoler.text = widget.event.description;
  }

  Future<void> _saveEvent() async {
    widget.event.name = nameController.text;
    widget.event.ram = ramController.text;
    widget.event.cpu = cpuControoler.text;
    widget.event.gpu = gpuController.text;
    widget.event.price = double.tryParse(priceControoler.text);
    widget.event.description = descriptionControoler.text;
    widget.event.status = dropdownValue;
    final updatedata = VirtualmachineModel(
        id: widget.event.id,
        name: widget.event.name,
        gpu: widget.event.gpu,
        cpu: widget.event.cpu,
        ram: widget.event.ram,
        description: widget.event.description,
        status: widget.event.status);
    await eventService.saveEvent(updatedata);
    await Mongodb.update(widget.event);
    if (!mounted) return;
    Navigator.of(context).pop(true);
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
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Ram'),
                TextField(
                  controller: ramController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Gpu'),
                TextField(
                  controller: gpuController,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Cpu'),
                TextField(
                  controller: cpuControoler,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Price'),
                TextField(
                  controller: priceControoler,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const Text('description'),
                TextField(
                  keyboardType: TextInputType.multiline,
                  controller: descriptionControoler,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0)),
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
                    FilledButton.icon(
                      onPressed: _saveEvent,
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
