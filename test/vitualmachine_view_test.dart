import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/view/virtualmachine_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
testWidgets('virtualmachineview', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: VirtualmachineView(),)
      );
   
  });
  
}
