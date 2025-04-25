import 'package:flutter/material.dart';

class EmptyVenueList extends StatelessWidget {
  const EmptyVenueList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.5, child: const Center(child: Text('No venues found'))),
      ],
    );
  }
}
