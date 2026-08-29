import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:linguago/app/app.dart';

void main() {
  testWidgets('App launches to the Get Started screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LinguagoApp()));

    expect(find.text('Break Free\nfrom Language\nBarriers'), findsOneWidget);
  });

  testWidgets('Get Started CTA navigates to the translator screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LinguagoApp()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Translate'), findsOneWidget);
    expect(find.text('Tap the mic to start speaking'), findsOneWidget);
  });
}
