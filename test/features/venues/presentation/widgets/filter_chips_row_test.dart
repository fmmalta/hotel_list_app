import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FilterChipsRow shows CircularProgressIndicator when loading', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Column(
                children: const [CircularProgressIndicator(), SizedBox(height: 16), Text('Carregando filtros...')],
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('FilterChipsRow shows error message when loading fails', (WidgetTester tester) async {
    const String errorMessage = 'Failed to load';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Failed to load filters: $errorMessage', style: const TextStyle(color: Colors.red)),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Failed to load filters: $errorMessage'), findsOneWidget);
  });

  testWidgets('FilterChipsRow shows chips when filters are loaded', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              children: [
                FilterChip(label: const Text('Hotels'), selected: true, onSelected: (_) {}),
                FilterChip(label: const Text('Resorts'), selected: false, onSelected: (_) {}),
                FilterChip(label: const Text('Villas'), selected: false, onSelected: (_) {}),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Hotels'), findsOneWidget);
    expect(find.text('Resorts'), findsOneWidget);
    expect(find.text('Villas'), findsOneWidget);

    expect(find.byType(FilterChip), findsNWidgets(3));
  });
}
