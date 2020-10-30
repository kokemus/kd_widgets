
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/src/submit_button.dart';
import 'package:mockito/mockito.dart';
import 'helpers.dart';

class Parent {
  Future onSubmit() { return Future.value(); }
  onStateChanged(SubmitButtonState state) {}
  void onPressed() {}
}

class MockParent extends Mock implements Parent {}

void main() {
  group('SubmitButton', () {
    final labels = {
      SubmitButtonState.initial : 'initial',
      SubmitButtonState.error : 'error',
      SubmitButtonState.success : 'success'
    };

    testWidgets('should be in initial state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        SubmitButton(labels: labels),
        themeData: ThemeData(
          accentColor: Colors.orange,
          accentTextTheme: TextTheme(button: TextStyle(color: Colors.green)),
        )
      );

      expect(find.byType(RaisedButton), findsOneWidget);
      final RaisedButton button = tester.firstWidget(find.byType(RaisedButton));
      expect(Colors.orange, button.color);
      expect(Colors.green, button.textColor);
      expect(find.text(labels[SubmitButtonState.initial].toUpperCase()), findsOneWidget);
    });


    testWidgets('should be in submitting state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SubmitButton(labels: labels, state: SubmitButtonState.submitting,));

      expect(find.byType(RaisedButton), findsOneWidget);
      final RaisedButton button = tester.firstWidget(find.byType(RaisedButton));
      expect(false, button.enabled);
      expect(Colors.grey, button.disabledColor);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should be in success state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SubmitButton(labels: labels, state: SubmitButtonState.success,));

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      final RaisedButton button = tester.firstWidget(
        find.raisedButtonWithIcon(Icons.check_circle_outline)
      );
      expect(Colors.green, button.color);
      expect(Colors.white, button.textColor);
      expect(find.text(labels[SubmitButtonState.success].toUpperCase()), findsOneWidget);
    });

    testWidgets('should be in error state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SubmitButton(labels: labels, state: SubmitButtonState.error,));

      final RaisedButton button = tester.firstWidget(
        find.raisedButtonWithIcon(Icons.error_outline)
      );
      expect(Colors.red, button.color);
      expect(Colors.white, button.textColor);
      expect(find.text(labels[SubmitButtonState.error].toUpperCase().toUpperCase()), findsOneWidget);
    });

    testWidgets('should call submit', (WidgetTester tester) async {
      final parent = MockParent();
      await tester.pumpMaterialWidget(
        SubmitButton(
          labels: labels, 
          onSubmit: parent.onSubmit,
          onStateChanged: parent.onStateChanged,
        ),
      );

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(parent.onSubmit());
      verify(parent.onStateChanged(SubmitButtonState.submitting));
    });

    testWidgets('should change to error state', (WidgetTester tester) async {
      final parent = MockParent();
      when(parent.onSubmit()).thenThrow(Exception());
      await tester.pumpMaterialWidget(
        SubmitButton(
          labels: labels, 
          onSubmit: parent.onSubmit,
          onStateChanged: parent.onStateChanged,
        ),
      );

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(parent.onSubmit());
      verify(parent.onStateChanged(SubmitButtonState.error));
    });

    testWidgets('should change to initial state', (WidgetTester tester) async {
      final parent = MockParent();
      await tester.pumpMaterialWidget(
        SubmitButton(
          labels: labels, 
          state: SubmitButtonState.success,
          onStateChanged: parent.onStateChanged,
          onPressed: parent.onPressed,
        )
      );

      await tester.tap(find.raisedButtonWithIcon(Icons.check_circle_outline));
      await tester.pump();

      verify(parent.onStateChanged(SubmitButtonState.initial));
      verify(parent.onPressed());
    });    

    testWidgets('should change to submitting state', (WidgetTester tester) async {
      final parent = MockParent();
      await tester.pumpMaterialWidget(
        SubmitButton(
          labels: labels, 
          state: SubmitButtonState.error,
          onStateChanged: parent.onStateChanged,
          onPressed: parent.onPressed,
        )
      );

      await tester.tap(find.raisedButtonWithIcon(Icons.error_outline));
      await tester.pump();

      verify(parent.onStateChanged(SubmitButtonState.submitting));
      verify(parent.onPressed());
    });    
  });
}
