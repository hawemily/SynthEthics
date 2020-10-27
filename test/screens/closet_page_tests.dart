import 'package:flutter_test/flutter_test.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';

void closet_page_tests() {

  testWidgets('Closet Test', (WidgetTester tester) async {
    await tester.pumpWidget(Closet(categories: ['cat1', 'cat2', 'cat3']));

    final categoriesFinder1 = find.text('cat1');
    final categoriesFinder2 = find.text('cat2');
    final categoriesFinder3 = find.text('cat3');

    expect(categoriesFinder1, findsOneWidget);
    expect(categoriesFinder2, findsOneWidget);
    expect(categoriesFinder3, findsOneWidget);
  });
}