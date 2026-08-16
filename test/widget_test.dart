import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:driver_ledger/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DriverLedgerApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Driver Ledger'), findsWidgets);
  });
}
