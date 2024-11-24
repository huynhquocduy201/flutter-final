import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
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

  Future<void> _saveEvent() async {
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> delteteEvents() async {
    await eventService.deleteEvent(widget.event);
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
              Text('Status:${widget.event.status}'),
            ]),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(widget.event.status == 'No users'
                        ? ''
                        : 'The device is currently occupied, please choose another device'))
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {
                        delteteEvents();
                        Navigator.of(context).pop(true);
                      },
                      label: const Text('Xoá sự kiện'),
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
                      label: const Text('Lưu sự kiện'),
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
