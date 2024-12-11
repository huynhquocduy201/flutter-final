import 'package:flutter/material.dart';
import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/view/virtualmachine_view_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Event viewdetail', (WidgetTester tester) async {
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
        home: VirtualmachineViewDetail(event: newEvent),
      ),
    );
    expect(find.text('GPU:RTX 4060'), findsOneWidget);
    expect(find.text('CPU:i9-13900K'), findsOneWidget);
    expect(find.text('RAM:32GB DRR5'), findsOneWidget);
    // Nhấn nút xoá sự kiện
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
    expect(find.byType(VirtualmachineViewDetail), findsNothing);
  });
}
