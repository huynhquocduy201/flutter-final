import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';

class ChangeEdtitPersonalView extends StatefulWidget {
  final UserModel event;
  const ChangeEdtitPersonalView({super.key, required this.event});

  @override
  State<ChangeEdtitPersonalView> createState() =>
      _ChangeEdtitPersonalViewState();
}

class _ChangeEdtitPersonalViewState extends State<ChangeEdtitPersonalView> {
  final usernameController = TextEditingController();

  final eventService = UserService();
  @override
  void initState() {
    super.initState();
    usernameController.text = widget.event.username;
  }

  Future<void> editusername() async {
    widget.event.username = usernameController.text;
    await eventService.saveEvent(widget.event);
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
          title: const Center(child: Text('Edit personal page')),
          actions: [
            GestureDetector(
              onTap: editusername,
              child: const Text(
                'Finished',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(0.8),
            child: Column(children: [
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                        bottom: BorderSide(width: 1, color: Colors.grey)),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      label: Text('Enter Username'),
                      enabledBorder: InputBorder.none,
                    ),
                  ))
            ])));
  }
}
