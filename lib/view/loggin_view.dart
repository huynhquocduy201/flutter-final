import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';
import 'package:flutter_project/view/signup_view.dart';
import 'package:flutter_project/view/virtualmachine_view.dart';

class LogginView extends StatefulWidget {
  const LogginView({super.key});

  @override
  State<LogginView> createState() => _LogginViewState();
}

class _LogginViewState extends State<LogginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final event = UserModel(username: '', password: '');
  final eventService = UserService();
  String? erorr;
  String test = '';
  List<UserModel> items = [];
  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final events = await eventService.getAllUser();
    setState(() {
      items = events;
    });
  }

  Future<void> login() async {
    if (items.any((e) =>
        e.password == passwordController.text &&
        e.username == usernameController.text)) {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => VirtualmachineView(
                  event: items.firstWhere((e) =>
                      e.password == passwordController.text &&
                      e.username == usernameController.text))))
          .then((value) async {
        if (value == true) {
          setState(() {
            loadEvents();
          });
        }
      });
    } else {
      setState(() {
        erorr = 'password or username is incorrect!';
      });
    }
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
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    label: const Text('User name'), errorText: erorr),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    label: const Text('Password'), errorText: erorr),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(child: Text('You dont have an account yet?')),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const SignupView()))
                          .then((value) async {
                        if (value == true) {
                          setState(() {
                            loadEvents();
                          });
                        }
                      });
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ))
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                  onPressed: login, label: const Text('Signin'))
            ])));
  }
}
