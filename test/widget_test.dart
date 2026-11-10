import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krm_alten/main.dart';

void main() {
  testWidgets('App loads Krm Alteen header and restaurant title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KrmAlteenApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('كرم التين'), findsWidgets);
  });
}
