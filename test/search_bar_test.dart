import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'helpers.dart';

void main() {
  group('SearchBar', () {
    testWidgets('should be in unfocus state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SearchBar());

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);

      final widget = SearchBar(onVoiceInput: () {},);
      await tester.pumpMaterialWidget(widget);

      expect(widget.preferredSize.height, kToolbarHeight);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should change to focus state when tapping text field', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SearchBar());

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);
    });   

    testWidgets('should change to focus state when pressing icon', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SearchBar());

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);
    });    

    testWidgets('should be in focus state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(SearchBar(initialState: SearchBarState.focus,));

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should change to active state', (WidgetTester tester) async {
      var query = '';
      await tester.pumpMaterialWidget(
        SearchBar(
          initialState: SearchBarState.focus,
          onQueryChanged: (value) => query = value,
        )
      );

      await tester.enterText(find.byType(TextField), 'q');
      await tester.pumpAndSettle();

      expect(query, 'q');
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should submit', (WidgetTester tester) async {
      var query = '';
      await tester.pumpMaterialWidget(
        SearchBar(
          initialState: SearchBarState.focus,
          onSubmitted: (value) => query = value,
        )
      );

      await tester.enterText(find.byType(TextField), 'q');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(query, 'q');
    }); 

    testWidgets('should clear query', (WidgetTester tester) async {
      var query = '';
      await tester.pumpMaterialWidget(
        SearchBar(
          initialState: SearchBarState.focus,
          onQueryChanged: (value) => query = value,
        )
      );

      await tester.enterText(find.byType(TextField), 'q');
      await tester.pumpAndSettle();

      expect(query, 'q');

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(query, '');
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should change to unfocus state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        SearchBar(
          initialState: SearchBarState.focus,
          onVoiceInput: () {},
        )
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });
  });

  group('SearchBar.expandable()', () {
    testWidgets('should be in focus state', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        SearchBar.expandable(onClose: null,)
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should close', (WidgetTester tester) async {
      var close = false;
      await tester.pumpMaterialWidget(
        SearchBar.expandable(onClose: () => close = true)
      );

      expect(close, false);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(close, true);
    });
  });
}