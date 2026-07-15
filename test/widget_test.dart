import 'package:flutter_test/flutter_test.dart';

import 'package:fuschoolvernew/main.dart';

void main() {
  testWidgets('Login screen loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that login screen text is present.
    expect(find.text('Chào mừng bạn trở lại!'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}
