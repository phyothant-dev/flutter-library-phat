import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phat/app.dart';

void main() {
  testWidgets('App shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PhatApp()));
    expect(find.text('ဖတ်'), findsOneWidget);
  });
}
