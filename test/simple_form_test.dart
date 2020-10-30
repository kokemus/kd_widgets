
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'package:mockito/mockito.dart';
import 'helpers.dart';

class Parent {
  Future onSubmit() { return Future.value(); }
  onEmailChanged(String value) {}
  onPasswordChanged(String value) {}
}

class MockParent extends Mock implements Parent {}

void main() {
  group('SimpleForm', () {
    testWidgets('should not call submit when form is invalid', (WidgetTester tester) async {
      final parent = MockParent();
      await tester.pumpMaterialWidget(
        SimpleForm.signIn(
          onEmailChanged: parent.onEmailChanged, 
          onPasswordChanged: parent.onPasswordChanged,
          onSubmit: parent.onSubmit, 
          emailFocus: null, 
          passwordFocus: null
        )
      );
      var email = 'foo@bar';
      await tester.enterText(find.byType(TextField).first, email);
      await tester.pumpAndSettle();

      verify(parent.onEmailChanged(email));
      verifyNever(parent.onPasswordChanged(any));

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verifyNever(parent.onSubmit());
    });

    testWidgets('should call submit when form is valid', (WidgetTester tester) async {
      final parent = MockParent();
      await tester.pumpMaterialWidget(
        SimpleForm.signIn(
          onEmailChanged: parent.onEmailChanged, 
          onPasswordChanged: parent.onPasswordChanged,
          onSubmit: parent.onSubmit, 
          emailFocus: null, 
          passwordFocus: null
        )
      );
      var email = 'foo@bar.fb';
      await tester.enterText(find.byType(TextField).first, email);
      await tester.pumpAndSettle();

      verify(parent.onEmailChanged(email));

      var password = 'abc123';
      await tester.enterText(find.byType(TextField).at(1), password);
      await tester.pumpAndSettle();

      verify(parent.onPasswordChanged(password));

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(parent.onSubmit());
    });
  });
}