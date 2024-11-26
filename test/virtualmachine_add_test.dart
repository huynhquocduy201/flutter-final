import 'package:flutter/material.dart';
import 'package:flutter_project/view/virtualmachine_view_create.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EventUpdate tạo sự kiện', (WidgetTester tester) async {
    // Tạo một sự kiện mới
  

    // Xây dựng ứng dụng
    await tester.pumpWidget(
     const MaterialApp(
        home:VirtualmachineViewCreate(),
      ),
    );
    await tester.enterText(find.byType(TextField).first, 'Máy 2');

 
    
  });
}
