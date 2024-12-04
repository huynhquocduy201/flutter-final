import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';

class ChangePasswordView extends StatefulWidget {
  final UserModel event;
  const ChangePasswordView({super.key, required this.event});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final repasswordController = TextEditingController();
  final passwordController = TextEditingController();

  final eventService = UserService();
  String? erorr;
  Future<void> chagepassword() async {
    widget.event.password = passwordController.text;
    if (passwordController.text == '' || repasswordController.text == '') {
      setState(() {
        erorr = 'Please fill in all information!';
      });
    } else {
      if (passwordController.text == repasswordController.text) {
        await eventService.saveEvent(widget.event);
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          erorr = 'Passwords do not match';
        });
      }
    }
  }

  void _resetEroor() {
    setState(() {
      erorr = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(0.8),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              TextField(
                controller: repasswordController,
                decoration: InputDecoration(
                    label: const Text('Enter Password'), errorText: erorr),
                onChanged: (text) {
                  _resetEroor();
                },
              ),
              const SizedBox(height: 50),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    label: const Text('Enter Re-password'), errorText: erorr),
                    onChanged: (text) {
                  _resetEroor();
                },
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                  onPressed: chagepassword, label: const Text('Change'))
            ])));
  }
}
