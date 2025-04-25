import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchBarSkeleton extends StatelessWidget {
  const SearchBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5.0, spreadRadius: 1.0)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(child: SizedBox(height: 24, child: const Text('Search for venue'))),
          ],
        ),
      ),
    );
  }
}
