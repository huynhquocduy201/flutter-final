import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/view/change_edtit_personal_view.dart';


import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Event chỉnh sửa username', (WidgetTester tester) async {
    final user = UserModel(username: 'dan1512003', password: 'dan1512003');
    // Xây dựng ứng dụng
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeEdtitPersonalView(event: user),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextField, 'Enter Username'), 'hi');
    await tester.tap(find.widgetWithText(GestureDetector, 'Finished'));
    await tester.pumpAndSettle();
    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
    expect(find.byType(ChangeEdtitPersonalView), findsNothing);
  });
}
