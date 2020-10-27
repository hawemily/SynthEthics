import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:synthetics/main.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:flutter/material.dart';

class MockClient extends Mock implements http.Client {}

void closet_page_tests() {

  testWidgets('Closet Test', (WidgetTester tester) async {
    final client = MockClient();
    when(client.get('https://us-central1-cfcalc.cloudfunctions.net/api/dummy'))
        .thenAnswer((_) async => http.Response('"hehe"', 200));

    await tester.pumpWidget(MyApp());
    await tester.tap(find.byIcon(Icons.sensor_window));


    //
    // await tester.pumpWidget(Closet(categories: ['cat1', 'cat2', 'cat3']));
    //
    // final categoriesFinder1 = find.text('cat1');
    // final categoriesFinder2 = find.text('cat2');
    // final categoriesFinder3 = find.text('cat3');
    //
    // expect(categoriesFinder1, findsOneWidget);
    // expect(categoriesFinder2, findsOneWidget);
    // expect(categoriesFinder3, findsOneWidget);
  });
}