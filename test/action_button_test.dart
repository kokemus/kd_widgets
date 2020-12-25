

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'helpers.dart';

void main() {
  group('ActionButton', () {
    testWidgets('should show idle state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        ActionButton(
          error: 'Error message',
          iconData: Icons.delete,
          onAction: () { return Future.value(true); },
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show progress state', (WidgetTester tester) async {
      final error = 'Error message';
      await tester.pumpMaterialWidget(
        ActionButton(
          error: error,
          iconData: Icons.delete,
          onAction: () {
            return Future.delayed(Duration(milliseconds: 20), () => true);
          },
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump(Duration(milliseconds: 10));

      expect(find.byType(IconButton), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(Duration(milliseconds: 10));

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(error), findsNothing);
    });

    testWidgets('should show error', (WidgetTester tester) async {
      final error = 'Error message';
      await tester.pumpMaterialWidget(
        Scaffold(
          body: ActionButton(
            error: error,
            iconData: Icons.delete,
            onAction: () {
              return Future.value(false);
            },
          ),
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(error), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });   
  });
}
