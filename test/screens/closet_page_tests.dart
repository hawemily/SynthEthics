import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:synthetics/main.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:flutter/material.dart';

class MockClient extends Mock implements http.Client {}

void catch_API_calls(http.Client client) {
  when(client.get('https://us-central1-cfcalc.cloudfunctions.net/api/dummy'))
      .thenAnswer((_) async => http.Response('"jaja"', 200));
}

void closet_page_tests() {
  testWidgets('Check closet page is loaded', (WidgetTester tester) async {
    final client = MockClient();

    catch_API_calls(client);

    await tester.pumpWidget(MyApp(client));
    await tester.tap(find.byIcon(Icons.sensor_window));
    await tester.pumpAndSettle();

    expect(find.text('Closet'), findsOneWidget);
  });

  testWidgets('Check closet tab bar is loaded', (WidgetTester tester) async {
    final client = MockClient();

    catch_API_calls(client);

    await tester.pumpWidget(MyApp(client));
    await tester.tap(find.byIcon(Icons.sensor_window));
    await tester.pump();

    final tabsFinder = find.byType(TabBarView);
    expect(tabsFinder, findsOneWidget);
  });
}
