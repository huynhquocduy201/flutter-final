import 'package:flutter/material.dart';
import 'package:flutter_project/view/loggin_view.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Event đăng nhập', (WidgetTester tester) async {
    // Xây dựng ứng dụng
    await tester.pumpWidget(
      const MaterialApp(
        home: LogginView(),
      ),
    );
    final findTextFieldUserName = find.widgetWithText(TextField, 'User name');
    expect(findTextFieldUserName, findsOneWidget);
    final findTextFieldPassword = find.widgetWithText(TextField, 'Password');
    expect(findTextFieldPassword, findsOneWidget);
    await tester.enterText(findTextFieldUserName, 'dan1512003');
    await tester.enterText(findTextFieldPassword, 'hi');
    final findFilledButtonSignin = find.widgetWithText(FilledButton, 'Signin');
    expect(findFilledButtonSignin, findsOneWidget);
    await tester.tap(findFilledButtonSignin);
    await tester.pumpAndSettle();

//kiểm có thực hiện đăng nhập được không
    expect(find.text('password or username is incorrect!'), findsWidgets);
  });
}
