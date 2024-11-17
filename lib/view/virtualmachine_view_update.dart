import 'package:flutter/material.dart';
import 'package:flutter_project/view/virtualmachine_view.dart';

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
  final descriptionControoler = TextEditingController();
  String dropdownValue = 'No users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upadate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name Vitual Machine'),
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
            const Text('description'),
            TextField(
              controller: descriptionControoler,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0)),
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
                    print(dropdownValue);
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const VirtualmachineView()));
                  },
                  label: const Text('Update'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
