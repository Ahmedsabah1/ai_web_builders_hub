import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_web_builders_hub/main.dart';

void main() {
  group('AI Web Builders Hub App Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should show splash screen or login screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Should find either splash screen or login screen elements
      await tester.pump();
      
      // Look for common elements that should be present
      expect(
        find.byType(Scaffold),
        findsWidgets, // Should find at least one scaffold
      );
    });

    testWidgets('App has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, 'AI Web Builders Hub');
    });

    testWidgets('App has theme configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });
}