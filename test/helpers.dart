import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterHelpers on WidgetTester {
  Future<void> pumpMaterialWidget(
    Widget widget,
    { ThemeData themeData }
  ) async {
    return await pumpWidget(
      MaterialApp(
        theme: themeData,
        home: Material(child: widget),
      )
    );
  }
}

extension CommonFindersHelpers on CommonFinders {
  Finder raisedButtonWithIcon(IconData icon) {
    return find.ancestor(
      of: find.byIcon(icon), 
      matching: find.byWidgetPredicate((widget) => widget is RaisedButton)
    );
  }
}