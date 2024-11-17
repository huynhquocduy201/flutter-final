import 'package:flutter_project/view/virtualmachine_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('hello world widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
         home: VirtualmachineView(),
      ),
    );
   
  });
}
