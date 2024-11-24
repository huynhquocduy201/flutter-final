import 'package:flutter/material.dart';
import 'package:flutter_project/dbHelper/mongodb.dart';
import 'package:flutter_project/view/loggin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Mongodb.connect();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LogginView());
  }
}
