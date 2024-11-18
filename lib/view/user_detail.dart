import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/view/change_password_view.dart';

class UserDetail extends StatefulWidget {
  final UserModel event;
  const UserDetail({super.key, required this.event});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('User Deatail'),
        ),
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
                    onTap: () => {print('ok')},
                    child: const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(widget.event.username),
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
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Signout'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
