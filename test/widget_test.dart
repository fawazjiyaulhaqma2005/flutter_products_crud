
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Aplikasi Product Store dapat dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductApp());

    expect(find.text('Product Store'), findsOneWidget);
  });
}
