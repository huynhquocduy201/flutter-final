import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';
import 'package:flutter_project/view/change_edtit_personal_view.dart';
import 'package:flutter_project/view/change_password_view.dart';
import 'package:flutter_project/view/loggin_view.dart';


class UserDetail extends StatefulWidget {
  final UserModel event;
  const UserDetail({super.key, required this.event});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  bool changetoggle = false;
  final eventService = UserService();
  String username = '';

  Future<void> loadEvents() async {
    final events = await eventService.getAllUser();

    final eventofid = events.firstWhere((e) => e.id == widget.event.id);
    setState(() {
      username == eventofid.username;
    });
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
        title: const Center(child: Text('User detail')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 80,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        changetoggle = true;
                      });
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(username != '' ? username : widget.event.username),
                      const Text('Admin')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChangePasswordView(event: widget.event)));
                    },
                    child: const Text('Change password'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  ChangeEdtitPersonalView(event: widget.event)))
                          .then((value) => {
                                if (value == true) {loadEvents()}
                              });
                    },
                    child: const Text('Edit personal page'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context) => const LogginView()) ,(Route<dynamic> route) => false);
                    },
                    child: const Text('Signout'),
                  )
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(height: 0),
            ),
            SizedBox(
                height: 120,
                child: Stack(children: [
                  AnimatedPositioned(
                      top: changetoggle ? 0 : 120, // Điều chỉnh vị trí của thẻ
                      left: 0,
                      right: 0,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        width: 1, color: Colors.grey),
                                    right: BorderSide(
                                        width: 1, color: Colors.grey),
                                    top: BorderSide(
                                        width: 1, color: Colors.grey),
                                    bottom: BorderSide(
                                        width: 1, color: Colors.grey)),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeEdtitPersonalView(
                                                    event: widget.event)))
                                        .then((value) => {
                                              if (value == true) {loadEvents()}
                                            });
                                  },
                                  child: const Text('Edit personal page'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(width: 1, color: Colors.grey),
                                  right:
                                      BorderSide(width: 1, color: Colors.grey),
                                  bottom:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePasswordView(
                                                    event: widget.event)));
                                  },
                                  child: const Text('Change password'),
                                )
                              ],
                            ),
                          ),
                          const AnimatedOpacity(
                              opacity: 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastEaseInToSlowEaseOut,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )),
                          Container(
                            height: 30,
                            decoration: const BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(width: 1, color: Colors.grey),
                                  right:
                                      BorderSide(width: 1, color: Colors.grey),
                                  bottom:
                                      BorderSide(width: 1, color: Colors.grey),
                                  top: BorderSide(width: 1, color: Colors.grey),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changetoggle = false;
                                    });
                                  },
                                  child: const Text('Cancel'),
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                ])),
          ],
        ),
      ),
    );
  }
}
