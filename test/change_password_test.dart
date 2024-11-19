import 'package:flutter/material.dart';
import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/view/change_password_view.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Event thay đổi mật khẩu', (WidgetTester tester) async {
    final user = UserModel(username: 'dan1512003', password: 'dan1512003');
    // Xây dựng ứng dụng
    await tester.pumpWidget(
      MaterialApp(
        home: ChangePasswordView(event: user),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextField, 'Enter Password'), 'hi');
    await tester.enterText(
        find.widgetWithText(TextField, 'Enter Re-password'), 'hi');
    await tester.tap(find.widgetWithText(FilledButton, 'Change'));
    await tester.pumpAndSettle();
    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
  expect(find.byType(ChangePasswordView), findsNothing);
  });
}
