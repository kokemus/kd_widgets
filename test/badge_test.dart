import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kd_widgets/kd_widgets.dart';
import 'helpers.dart';

void main() {
  group('Badge', () {
    testWidgets('should show one digit with default style', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        Badge(number: '1',),
        themeData: ThemeData(
          accentColor: Colors.red
        )
      );

      expect(find.text('1'), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style.color, Colors.white);
      final container = tester.widget<Container>(find.byType(Container));
      expect((container.decoration as BoxDecoration).color, Colors.red);
    });

    testWidgets('should show w/o number with default style', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        Badge(),
        themeData: ThemeData(
          accentColor: Colors.red
        )
      );

      expect(find.byType(Text), findsNothing);
      final container = tester.widget<Container>(find.byType(Container));
      expect((container.decoration as BoxDecoration).color, Colors.red);
    });    

    testWidgets('should show two digit with custom style', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        Badge(number: '99', color: Colors.black, backgroundColor: Colors.yellowAccent,),
      );

      expect(find.text('99'), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style.color, Colors.black);
      final container = tester.widget<Container>(find.byType(Container));
      expect((container.decoration as BoxDecoration).color, Colors.yellowAccent);
    });     
  });

  group('WithBadge', () {
    testWidgets('should show unselected bottom navigation bar item with badge', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        BottomNavigationBar(
          currentIndex: 1,
          items: [
            WithBadge.bottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Item 1',
              badge: Badge(number: '99', color: Colors.black, backgroundColor: Colors.yellowAccent,),
            ),          
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Item 2'),
          ],
        )
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('should show selected bottom navigation bar item w/o badge', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        BottomNavigationBar(
          items: [
            WithBadge.bottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Item 1',
              badge: Badge(number: '99', color: Colors.black, backgroundColor: Colors.yellowAccent,),
            ),          
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Item 2'),
          ],
        )
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.text('99'), findsNothing);
      expect(find.text('Item 2'), findsOneWidget);
    });
    
    testWidgets('should show unselected tab with badge', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: [
              WithBadge.tab(
                icon: Icon(Icons.help),
                text: 'Item 1',
                badge: Badge(number: '99', color: Colors.black, backgroundColor: Colors.yellowAccent,),
              ),          
              Tab(icon: Icon(Icons.warning), text: 'Item 2'),
            ],
          ),
        )
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });    
  });
}