import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'helpers.dart';

void main() {
  group('Filter', () {
    test('toString', () {      
      final filter = Filter('foo', 'bar', false);
      expect(filter.toString(), 'Filter(${filter.key}: ${filter.value})');
    });

  });  

  group('FilterRow', () {
    testWidgets('should show filters with wrapping', (WidgetTester tester) async {
      final filters = [
        Filter('Filter 1', 'filter1', false),
        Filter('Filter 2', 'filter2', false),
        Filter('Filter 3', 'filter3', false),
      ];

      await tester.pumpMaterialWidget(
        FilterRow.horizontalWrap(
          filters: filters, 
          onChanged: (List<Filter> value) {  },
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.text(filters[0].label), findsOneWidget);
      expect(find.text(filters[1].label), findsOneWidget);
      expect(find.text(filters[2].label), findsOneWidget);
    });

    testWidgets('should show filters with scrolling', (WidgetTester tester) async {
      final filters = [
        Filter('Filter 1', 'filter1', false),
        Filter('Filter 2', 'filter2', false),
        Filter('Filter 3', 'filter3', false),
      ];

      await tester.pumpMaterialWidget(
        FilterRow.horizontalScroll(
          filters: filters, 
          onChanged: (List<Filter> value) {  },
        ),
      );

      expect(find.byType(Wrap), findsNothing);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text(filters[0].label), findsOneWidget);
      expect(find.text(filters[1].label), findsOneWidget);
      expect(find.text(filters[2].label), findsOneWidget);
    });    

    testWidgets('should select one choice', (WidgetTester tester) async {
      var filters = [
        Filter('Filter 1', 'filter1', false),
        Filter('Filter 2', 'filter2', false),
        Filter('Filter 3', 'filter3', false),
      ];

      await tester.pumpMaterialWidget(
        FilterRow(
          filters: filters,
          multipleChoice: false,
          onChanged: (List<Filter> value) { filters = value;  },
        ),
      );

      await tester.tap(find.byType(FilterChip).at(0));
      await tester.tap(find.byType(FilterChip).at(1));

      await tester.pumpAndSettle();
      
      expect(filters[0].value, false);
      expect(filters[1].value, true);
      expect(filters[2].value, false);
    });

    testWidgets('should select multiple choices', (WidgetTester tester) async {
      var filters = [
        Filter('Filter 1', 'filter1', false),
        Filter('Filter 2', 'filter2', false),
        Filter('Filter 3', 'filter3', false),
      ];

      await tester.pumpMaterialWidget(
        FilterRow(
          filters: filters,
          onChanged: (List<Filter> value) { filters = value;  },
        ),
      );

      await tester.tap(find.byType(FilterChip).at(0));
      await tester.tap(find.byType(FilterChip).at(1));

      await tester.pumpAndSettle();
      
      expect(filters[0].value, true);
      expect(filters[1].value, true);
      expect(filters[2].value, false);
    });  
  });
}