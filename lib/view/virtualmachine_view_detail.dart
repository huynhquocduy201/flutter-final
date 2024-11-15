import 'package:flutter/material.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';

class VirtualmachineViewDetail extends StatefulWidget {
  const VirtualmachineViewDetail({super.key});

  @override
  State<VirtualmachineViewDetail> createState() =>
      _VirtualmachineViewDetailState();
}

class _VirtualmachineViewDetailState extends State<VirtualmachineViewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Máy 1'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('GPU: RTX 4060'),
                SizedBox(width: 10),
                Text('CPU:i9-13900K '),
                SizedBox(width: 10),
                Text('RAM: 32GB DRR5'),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              children: [Text('Discription here')],
            ),
            const SizedBox(height: 15),
            const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Price: 0.59USD/1h'), Text('Status:playing')]),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'The device is currently occupied, please choose another device')
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    print('Xoá sự kiên');
                  },
                  label: const Text('Xoá sự kiện'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const VirtualmachineViewUpdate()));
                  },
                  label: const Text('Lưu sự kiện'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
