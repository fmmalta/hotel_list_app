import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/venues/domain/entities/category_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:mockito/mockito.dart';

class MockVenuesBloc extends Mock implements VenuesBloc {
  @override
  Stream<VenuesState> get stream => Stream.value(VenuesInitial());

  @override
  VenuesState get state => VenuesInitial();

  @override
  void add(VenuesEvent event) {}
}

class TestFilterChip extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback? onSelected;

  const TestFilterChip({super.key, required this.category, required this.isSelected, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          if (onSelected != null) onSelected!();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }
}

void main() {
  testWidgets('FilterChip renders correctly when not selected', (WidgetTester tester) async {
    final category = CategoryEntity(id: '1', name: 'Hotels');

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TestFilterChip(category: category, isSelected: false))));

    expect(find.text('Hotels'), findsOneWidget);
    final chip = tester.widget<FilterChip>(find.byType(FilterChip));
    expect(chip.selected, false);

    final textWidget = tester.widget<Text>(find.text('Hotels'));
    expect((textWidget.style?.color), Colors.black54);
    expect((textWidget.style?.fontWeight), FontWeight.normal);
  });

  testWidgets('FilterChip renders correctly when selected', (WidgetTester tester) async {
    final category = CategoryEntity(id: '1', name: 'Hotels');

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TestFilterChip(category: category, isSelected: true))));

    expect(find.text('Hotels'), findsOneWidget);
    final chip = tester.widget<FilterChip>(find.byType(FilterChip));
    expect(chip.selected, true);

    final textWidget = tester.widget<Text>(find.text('Hotels'));
    expect((textWidget.style?.color), Colors.white);
    expect((textWidget.style?.fontWeight), FontWeight.bold);
  });

  testWidgets('FilterChip calls callback when tapped', (WidgetTester tester) async {
    final category = CategoryEntity(id: '1', name: 'Hotels');
    bool callbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestFilterChip(
            category: category,
            isSelected: false,
            onSelected: () {
              callbackCalled = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(FilterChip));
    await tester.pump();

    expect(callbackCalled, true);
  });
}
