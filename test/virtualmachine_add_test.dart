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

    // Nhấn nút Lưu sự kiện
    await tester.tap(find.widgetWithText(FilledButton, 'Create'));
    await tester.pumpAndSettle();
expect(find.byType(VirtualmachineViewCreate), findsNothing);
    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
    
  });
}
