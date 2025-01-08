import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/view/virtualmachine_view_update.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EventUpdate cập nhất sự kiện', (WidgetTester tester) async {
    // Tạo một sự kiện mới
    final newEvent = VirtualmachineModel(
      id: '1',
      name: 'máy 1',
      gpu: 'RTX 4060',
      cpu: 'i9-13900K',
      ram: '32GB DRR5',
      price: 0.59,
      description: 'No Content',
      status: 'No Users',
    );

    // Xây dựng ứng dụng
    await tester.pumpWidget(
      MaterialApp(
        home: VirtualmachineViewUpdate(event: newEvent),
      ),
    );
    await tester.enterText(find.byType(TextField).first, 'Máy 2');

    // Nhấn nút Lưu sự kiện
    await tester.tap(find.widgetWithText(FilledButton, 'Update'));
    await tester.pumpAndSettle();

    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
    expect(find.byType(VirtualmachineViewUpdate), findsNothing);
  });
}
