import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/view/virtualmachine_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userModel = UserModel(username: 'dan1512003', password: 'dan1512003');
  testWidgets('virtualmachineview', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: VirtualmachineView(event: userModel),
    ));
  });
}
