import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'index.dart';

class VenueScreenSkeleton extends StatelessWidget {
  const VenueScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading venues',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterChipsSkeleton(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Expanded(child: SearchBarSkeleton()),
                  const SizedBox(width: 8),
                  Skeletonizer(enabled: true, child: IconButton(onPressed: null, icon: const Icon(Icons.filter_list))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeletonizer(
                    enabled: true,
                    child: const Text('10 venues found', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Skeletonizer(
                    enabled: true,
                    child: Row(
                      children: [
                        const Text('Sort: ', style: TextStyle(color: Colors.grey)),
                        const Text('Newest', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(child: VenueListSkeleton()),
          ],
        ),
      ),
    );
  }
}
