import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Hotel filtering tests', () {
    testWidgets('Filter and search interface', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Hotel List'),
              actions: const [IconButton(icon: Icon(Icons.search), onPressed: null)],
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(label: const Text('Todos'), selected: true, onSelected: (_) {}),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(label: const Text('Hotels'), selected: false, onSelected: (_) {}),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: FilterChip(label: const Text('Resorts'), selected: false, onSelected: (_) {}),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search hotels...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {},
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Example Hotel'),
                          subtitle: Text('Hotel Location'),
                          trailing: Text('\$250'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Hotel List'), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));

      await tester.tap(find.widgetWithText(FilterChip, 'Hotels'));
      await tester.pump();

      expect(find.widgetWithText(FilterChip, 'Hotels'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Resort');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('Resort'), findsOneWidget);
    });
  });
}
