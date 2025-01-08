import 'package:flutter/material.dart';
import 'package:flutter_project/view/signup_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Event đăng ký', (WidgetTester tester) async {
    // Xây dựng ứng dụng
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupView(),
      ),
    );


    await tester.enterText(find.widgetWithText(TextField, 'User name'), 'dan1512003');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'hi');
    await tester.enterText( find.widgetWithText(TextField, 'Re-password'),'hi');
    await tester.tap(find.widgetWithText(FilledButton, 'Signup'));
    await tester.pumpAndSettle();
    // Kiểm tra xem Navigator đã pop hay chưa (tức là trở về màn hình trước)
  expect(find.byType(SignupView), findsNothing);
  });
}
