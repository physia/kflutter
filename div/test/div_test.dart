import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:div/div.dart';

void main() {
  // this will test the [Div] widget and its constructors [Div.col] and [Div.row] in defferent ways
  // using single [Widget] as the [child] and [Widget] list as the [children] and null as the [child]
  testWidgets('test the Div widget', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      Div(null),
    );
    // should be eqevalent to an empty [Container]
    expect(find.byType(Div), findsOneWidget);
    // the Container will be wrapped in a [GestureDetector]
    await tester.pumpWidget(
      Div(
        null,
        color: Colors.red,
        onTap: () {
          print('tap on the Div');
        },
      ),
    );
    // should be eqevalent to an empty [Container]
    expect(find.byType(Div), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
  });
  // test the [Div.col] constructor
  testWidgets('test the Div.col constructor', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div.col(
          [Text('Hello from column')],
          color: Colors.green,
          onTap: () {
            print('tap on the Div');
          },
        ),
      ),
    );
    expect(find.byType(Div), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.text('Hello from column'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
  });
  // test the [Div.row] constructor
  testWidgets('test the Div.row constructor', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div.row(
          [Text('Hello from row')],
          color: Colors.green,
          onTap: () {
            print('tap on the Div');
          },
        ),
      ),
    );
    expect(find.byType(Div), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.text('Hello from row'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });
  // test nested widgets
  testWidgets('test nested widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Div.col(
          [
            Expanded(
              child: Div.row(
                [Text('Hello from row')],
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Div.col(
                [Text('Hello from column')],
                color: Colors.green,
                onTap: () {
                  print('tap on the Div');
                },
              ),
            ),
          ],
          color: Colors.green,
          onTap: () {
            print('tap on the Div');
          },
        ),
      ),
    );
    expect(find.byType(Div), findsNWidgets(3));
    expect(find.byType(GestureDetector), findsNWidgets(2));
    expect(find.text('Hello from row'), findsOneWidget);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.byType(Row), findsOneWidget);
    expect(find.text('Hello from column'), findsOneWidget);
    expect(find.byType(Column), findsNWidgets(2));
  });
}
