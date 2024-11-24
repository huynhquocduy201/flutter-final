import 'package:flutter_project/model/user_model.dart';
import 'package:flutter_project/view/user_detail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  final userModel =
      UserModel(username: 'dan1512003', password: 'dan1512003', id: '1512003');
  testWidgets('Kiểm thử widget user detail', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UserDetail(event: userModel),
      ),
    );

    final findtapChangePassword =
        find.widgetWithText(GestureDetector, 'Change password');
    expect(findtapChangePassword, findsNWidgets(2));

    final findtapEditPersonal =
        find.widgetWithText(GestureDetector, 'Edit personal page');
    expect(findtapEditPersonal, findsNWidgets(2));
    //await tester.tap(findtapChangePassword.first);

    await tester.tap(findtapEditPersonal.first);
    await tester.pumpAndSettle();
    // Kiểm tra xem Navigator đã push hay chưa (tức chuyển sang trang đổi  username)
    expect(find.byType(UserDetail), findsNothing);
  });
}
