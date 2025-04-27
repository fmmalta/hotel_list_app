import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_list_app/core/error/error_state_checkers.dart';
import 'package:hotel_list_app/core/error/widgets/error_display_widget.dart';
import 'package:hotel_list_app/features/venues/domain/entities/venue_entity.dart';
import 'package:hotel_list_app/features/venues/presentation/venue_detail_bloc/venue_detail_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/venue_detail_bloc/venue_event.dart';
import 'package:hotel_list_app/features/venues/presentation/venue_detail_bloc/venue_state.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/skeletons/index.dart';

import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VenueDetailScreen extends StatefulWidget {
  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late VenueDetailBloc _venueDetailBloc;
  GoogleMapController? mapController;
  bool _isMapReady = false;
  bool _isMapVisible = false;
  final ValueNotifier<bool> _shouldShowMap = ValueNotifier<bool>(false);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mounted) {
      setState(() {
        _isMapReady = true;
        _isMapVisible = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _venueDetailBloc = VenueDetailBloc()..add(FetchVenueDetailEvent(id: widget.venueId));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _shouldShowMap.value = true;
        _isMapVisible = true;
      }
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    _shouldShowMap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VenueDetailBloc, VenueDetailState>(
        bloc: _venueDetailBloc,
        builder: (context, state) {
          if (state is VenueDetailLoading) {
            return const VenueDetailSkeleton();
          } else if (state is VenueDetailLoaded) {
            return _buildVenueDetail(state.venue).withVenueDetailErrorListener(
              context,
              bloc: _venueDetailBloc,
              onRetry: () => _venueDetailBloc.add(FetchVenueDetailEvent(id: widget.venueId)),
              showSnackBarInsteadOfDialog: true,
            );
          } else if (state is VenueDetailError) {
            return _buildErrorView(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorView(VenueDetailError state) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/error_background.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          ),
        ),

        ErrorDisplayWidget(
          title: 'Venue details unavailable',
          message: state.message,
          onRetry: state.isRecoverable ? () => _venueDetailBloc.add(FetchVenueDetailEvent(id: widget.venueId)) : null,
          retryText: 'Try Again',
          additionalActions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back'))],
        ),
      ],
    );
  }

  Widget _buildVenueDetail(VenueEntity venue) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(venue),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVenueHeader(venue),
              ...venue.activities.map((activity) => _buildExpandableSection(title: activity, content: activity)),
              ...venue.facilities.map((facility) => _buildExpandableSection(title: facility, content: facility)),
              ...venue.thingsToDo.map(
                (thingToDo) => _buildExpandableSection(
                  title: thingToDo.title,
                  content: thingToDo.badge ?? thingToDo.content ?? thingToDo.subtitle ?? '-',
                ),
              ),
              const SizedBox(height: 16),
              _buildLazyMap(venue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(VenueEntity venue) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      flexibleSpace: FlexibleSpaceBar(background: _buildImageCarousel(venue)),
    );
  }

  Widget _buildImageCarousel(VenueEntity venue) {
    return ExpandableCarousel.builder(
      itemCount: venue.imageUrls.length,
      itemBuilder: (context, index, pageViewIndex) {
        final image = venue.imageUrls[index];
        return CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder:
              (context, url) =>
                  Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
      options: ExpandableCarouselOptions(viewportFraction: 1.0),
    );
  }

  Widget _buildVenueHeader(VenueEntity venue) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(venue.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(venue.location, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Opening hours:', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            '${DateFormat('Hms').format(venue.createdAt)} - ${DateFormat('Hms').format(venue.createdAt.add(const Duration(hours: 12)))}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Text(venue.overview, style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.4)),
          const Divider(height: 32),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({required String title, required String content, bool isLastItem = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
              Text(content, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            ],
          ),
        ),
        if (!isLastItem) const Divider(height: 32),
      ],
    );
  }

  Widget _buildLazyMap(VenueEntity venue) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(
              color: Colors.grey[200],
              width: double.infinity,
              height: 300,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('Loading map...', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _shouldShowMap,
              builder: (context, shouldShowMap, child) {
                if (!shouldShowMap) {
                  return const SizedBox.shrink();
                }

                return VisibilityDetector(
                  key: const Key('map-visibility-detector'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    _isMapVisible = info.visibleFraction > 0.1;
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (_isMapVisible) {
                        return GoogleMap(
                          onMapCreated: _onMapCreated,
                          zoomControlsEnabled: false,
                          liteModeEnabled: true,
                          markers: {
                            Marker(
                              markerId: MarkerId(venue.id),
                              position: LatLng(venue.latitude, venue.longitude),
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(venue.latitude, venue.longitude),
                            zoom: 15.0,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                );
              },
            ),
            if (!_isMapReady) Positioned.fill(child: Container(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
