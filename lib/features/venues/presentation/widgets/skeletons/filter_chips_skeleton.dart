import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FilterChipsSkeleton extends StatelessWidget {
  const FilterChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return Chip(
              label: const Text('Filter Option'),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
