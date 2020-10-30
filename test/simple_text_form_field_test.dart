import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/src/simple_text_form_field.dart';
import 'helpers.dart';

void main() {
  group('SimpleTextFormField', () {
    testWidgets('onChanged should show valid icon', (WidgetTester tester) async {
      final expected = 'hello';
      var state = '';
      await tester.pumpMaterialWidget(SimpleTextFormField(
        validator: (v) => v.length > 2 ? null : '',
        onChanged: (v) => state = v,
      ),);

      expect(find.byIcon(Icons.check), findsNothing);

      await tester.enterText(find.byType(TextField), expected);
      await tester.pumpAndSettle();

      expect(state, expected);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should submit', (WidgetTester tester) async {
      final expected = 'hello';
      final node = FocusNode();
      final nextNode = FocusNode();
      var state = '';
      await tester.pumpMaterialWidget(SimpleTextFormField(
        textInputAction: TextInputAction.done,
        validator: (v) => v.length > 2 ? null : '',
        onChanged: (v) => state = v,
        node: node,
        nextNode: nextNode,
      ),);

      expect(find.byIcon(Icons.check), findsNothing);

      await tester.enterText(find.byType(TextField), expected);
      expect(node.hasFocus, isTrue);
      expect(nextNode.hasFocus, isFalse);

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(state, expected);
      expect(node.hasFocus, isFalse);
    });
  });

  group('SimpleTextFormField.email', () {
    testWidgets('onChanged should show valid icon', (WidgetTester tester) async {
      final expected = 'foo@bar.fb';
      var state = '';
      await tester.pumpMaterialWidget(SimpleTextFormField.email(
        onChanged: (v) => state = v,
      ),);

      expect(find.byIcon(Icons.check), findsNothing);

      await tester.enterText(find.byType(TextField), expected);
      await tester.pumpAndSettle();

      expect(state, expected);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
