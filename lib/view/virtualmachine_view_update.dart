import 'package:flutter/material.dart';

class VirtualmachineViewUpdate extends StatefulWidget {
  const VirtualmachineViewUpdate({super.key});

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
  String? _selectvalue;

  List<String> itemselects = ["there are users", "no users"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upadate'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tên máy'),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
       
          ],
        ),
      ),
    );
  }
}
