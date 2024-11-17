import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
import 'package:flutter_project/view/virtualmachine_view.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';

class VirtualmachineViewDetail extends StatefulWidget {
  final VirtualmachineModel event;
  const VirtualmachineViewDetail({super.key, required this.event});

  @override
  State<VirtualmachineViewDetail> createState() =>
      _VirtualmachineViewDetailState();
}

class _VirtualmachineViewDetailState extends State<VirtualmachineViewDetail> {
  final eventService = VirtualmachineService();

  Future<void> delteteEvents() async {
    await eventService.deleteEvent(widget.event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.event.gpu),
                const SizedBox(width: 10),
                Text(widget.event.cpu),
                const SizedBox(width: 10),
                Text(widget.event.ram),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [Text(widget.event.description)],
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Price:${widget.event.price} '),
              Text('Status:${widget.event.status}')
            ]),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.event.status == 'No users'
                    ? ''
                    : 'The device is currently occupied, please choose another device')
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    delteteEvents();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const VirtualmachineView()));
                  },
                  label: const Text('Xoá sự kiện'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            VirtualmachineViewUpdate(event: widget.event)));
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
