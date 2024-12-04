import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/service/user_service.dart';

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
  bool showPass = true;
  bool showRePass = true;
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

  Future<void> signup() async {
    event.username = usernameController.text;
    event.password = passwordController.text;

    if (items.any((e) => e.username == usernameController.text)) {
      setState(() {
        erorrUserName = 'Username already exists!';
      });
    } else if (passwordController.text != repasswordController.text) {
      setState(() {
        erorrPassword = 'Password does not match!';
      });
    } else if (items.any((e) => e.username == usernameController.text) &&
        passwordController != repasswordController) {
      setState(() {
        erorrPassword = 'Password does not match1!';
        erorrUserName = 'Username already exists!';
      });
    } else if (usernameController.text == '' ||
        passwordController.text == '' ||
        repasswordController.text == '') {
      setState(() {
        erorrPassword = erorrUserName = 'Please fill in all information!';
      });
    } else {
      await eventService.saveEvent(event);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  void _resetEroor() {
    setState(() {
      erorrPassword = null;
      erorrUserName = null;
    });
  }

  void _showPassword() {
    setState(() {
      showPass = !showPass;
    });
  }

  void _showRePassword() {
    setState(() {
      showRePass = !showRePass;
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
                onChanged: (text) {
                  _resetEroor();
                },
              ),
              const SizedBox(height: 50),
              TextField(
                controller: passwordController,
                obscureText: showPass,
                decoration: InputDecoration(
                    label: const Text('Password'),
                    errorText: erorrPassword,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _showPassword();
                        },
                        icon: Icon(showPass
                            ? Icons.visibility_off
                            : Icons.visibility))),
                onChanged: (text) {
                  _resetEroor();
                },
              ),
              const SizedBox(height: 50),
              TextField(
                controller: repasswordController,
                obscureText: showRePass,
                decoration: InputDecoration(
                    label: const Text('Re-password'),
                    errorText: erorrPassword,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _showRePassword();
                        },
                        icon: Icon(showRePass
                            ? Icons.visibility_off
                            : Icons.visibility))),
                onChanged: (text) {
                  _resetEroor();
                },
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                  onPressed: signup, label: const Text('Signup'))
            ])));
  }
}
