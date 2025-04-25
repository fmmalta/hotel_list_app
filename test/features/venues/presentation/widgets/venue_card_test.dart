import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestVenueCard extends StatelessWidget {
  final String name;
  final String location;
  final double price;
  final double rating;
  final List<String> facilities;
  final VoidCallback? onTap;

  const TestVenueCard({
    super.key,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.facilities,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(location, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (facilities.isNotEmpty) Text(facilities.first),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  const testName = 'Test Hotel';
  const testLocation = 'Test Location';
  const testPrice = 250.0;
  const testRating = 4.5;
  const testFacilities = ['WiFi', 'Pool'];

  testWidgets('VenueCard displays hotel information correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TestVenueCard(
              name: testName,
              location: testLocation,
              price: testPrice,
              rating: testRating,
              facilities: testFacilities,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Test Hotel'), findsOneWidget);

    expect(find.text('Test Location'), findsOneWidget);

    expect(find.text('\$250'), findsOneWidget);

    expect(find.text('4.5'), findsOneWidget);

    expect(find.text('WiFi'), findsOneWidget);

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('VenueCard chama onTap ao ser tocado', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TestVenueCard(
              name: testName,
              location: testLocation,
              price: testPrice,
              rating: testRating,
              facilities: testFacilities,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(tapped, true);
  });
}
