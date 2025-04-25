import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VenueDetailSkeleton extends StatelessWidget {
  const VenueDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        slivers: [
          _buildAppBarSkeleton(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVenueHeaderSkeleton(),
                ..._buildSectionSkeletons(4),
                const SizedBox(height: 16),
                _buildMapSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarSkeleton() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.close, color: Colors.black),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Colors.grey[300], width: double.infinity, height: 200),
      ),
    );
  }

  Widget _buildVenueHeaderSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Venue Name Example', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Location Example, City', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              const Text('4.5', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              const Text('\$150', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildSectionSkeletons(int count) {
    return List.generate(count, (index) => _buildExpandableSectionSkeleton());
  }

  Widget _buildExpandableSectionSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 3, spreadRadius: 1)],
      ),
      child: ExpansionTile(
        title: const Text('Section Title Example'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Content example item with some information to display'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSkeleton() {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('Map Area', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
