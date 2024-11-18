import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';
import 'package:flutter_project/view/loggin_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
  final event = UserModel(username: '', password: '');
  final eventService = UserService();
  String? erorrUserName;
  String? erorrPassword;

  Future<void> signup() async {
    event.username = usernameController.text;
    event.password = passwordController.text;
    final eventgetAll = await eventService.getAllUser();
    if (eventgetAll.any((e) => e.username == usernameController.text)) {
      setState(() {
        erorrUserName = 'Username already exists!';
      });
    } else if (passwordController.text != repasswordController.text) {
      setState(() {
        erorrPassword = 'Password does not match!';
      });
    } else if (eventgetAll.any((e) => e.username == usernameController.text) &&
        passwordController != repasswordController) {
      setState(() {
        erorrPassword = 'Password does not match1!';
        erorrUserName = 'Username already exists!';
      });
    } else {
      await eventService.saveEvent(event);

      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogginView()));
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
                    'Signup',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    label: const Text('User name'), errorText: erorrUserName),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    label: const Text('Password'), errorText: erorrPassword),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: repasswordController,
                decoration: InputDecoration(
                    label: const Text('Enter Re-password'),
                    errorText: erorrPassword),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                  onPressed: signup, label: const Text('Signup'))
            ])));
  }
}
