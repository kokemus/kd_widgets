import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'helpers.dart';

void main() {
  group('ActionSwitch', () {
    testWidgets('should show idle state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        ActionSwitch(
          error: 'Error message',
          value: true,
          onAction: (value) { return Future.value(true); },
        ),
      );

      final Switch button = tester.firstWidget(find.byType(Switch));
      expect(button.value, isTrue);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show progress state', (WidgetTester tester) async {
      final error = 'Error message';
      await tester.pumpMaterialWidget(
        ActionSwitch(
          error: error,
          value: false,
          onAction: (value) {
            return Future.delayed(Duration(milliseconds: 20), () => true);
          },
        ),
      );

      final Switch button = tester.firstWidget(find.byType(Switch));
      expect(button.value, isFalse);

      await tester.tap(find.byType(Switch));
      await tester.pump(Duration(milliseconds: 10));

      expect(find.byType(Switch), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(Duration(milliseconds: 10));

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(error), findsNothing);
    });

    testWidgets('should show error', (WidgetTester tester) async {
      final error = 'Error message';
      await tester.pumpMaterialWidget(
        Scaffold(
          body: ActionSwitch(
            error: error,
            value: true,
            onAction: (value) {
              return Future.value(false);
            },
          ),
        ),
      );
      await tester.tap(find.byType(Switch));
      await tester.pump(Duration(milliseconds: 30));

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text(error), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });   
  });
}
