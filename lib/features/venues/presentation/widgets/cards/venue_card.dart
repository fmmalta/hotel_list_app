import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/pages/venue_detail_screen.dart';

class VenueCard extends StatelessWidget {
  final VenueEntity venue;

  const VenueCard({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Venue card for ${venue.name}',
      hint: 'Tap to view details for ${venue.name} in ${venue.location}',
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VenueDetailScreen(venueId: venue.id)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5.0, spreadRadius: 1.0)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Semantics(
                    label: 'Image gallery of ${venue.name}',
                    excludeSemantics: true,
                    child: FlutterCarousel.builder(
                      itemCount: venue.imageUrls.length,
                      itemBuilder: (context, index, pageIndex) {
                        final imageUrl = venue.imageUrls[index];
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[200]),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error_outline, size: 32, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(color: Colors.grey[600]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        );
                      },
                      options: FlutterCarouselOptions(aspectRatio: 16 / 9, viewportFraction: 1.0),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Semantics(
                      label: 'Rating: ${venue.rating} stars',
                      excludeSemantics: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              venue.rating.toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MergeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venue.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            venue.location,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: 'Price: ${venue.price.toStringAsFixed(0)} dollars',
                          child: Text(
                            '\$${venue.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                        ),
                        Semantics(
                          label: 'Facility: ${venue.facilities.isNotEmpty ? venue.facilities.first : 'Hotel'}',
                          child: Text(
                            venue.facilities.isNotEmpty ? venue.facilities.first : 'Hotel',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
