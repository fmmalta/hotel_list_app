import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_event.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/index.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  State<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  late VenuesBloc venuesBloc;
  late FilterBloc filterBloc;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    venuesBloc = VenuesBloc()..add(const VenuesFetchEvent(resetFilters: true));
    filterBloc = FilterBloc()..add(FilterFetchEvent());
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    venuesBloc.close();
    filterBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isLoading && venuesBloc.state is VenuesLoaded) {
      final state = venuesBloc.state as VenuesLoaded;
      if (!state.hasReachedMax) {
        setState(() => _isLoading = true);
        venuesBloc.add(VenuesFetchNextPageEvent(page: state.currentPage + 1));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider<VenuesBloc>.value(value: venuesBloc),
              BlocProvider<FilterBloc>.value(value: filterBloc),
            ],
            child: const FilterModal(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'PRIVILEE',
          style: TextStyle(color: Color(0xFF2D3C4E), fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<VenuesBloc>.value(value: venuesBloc),
          BlocProvider<FilterBloc>.value(value: filterBloc),
        ],
        child: BlocConsumer<VenuesBloc, VenuesState>(
          listener: (context, state) {
            if (state is VenuesLoaded || state is VenuesError || state is VenuesNoResults) {
              setState(() => _isLoading = false);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FilterChipsRow(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: SearchBarWidget(initialQuery: state is VenuesLoaded ? state.searchQuery : '')),
                      const SizedBox(width: 8),
                      _buildFilterButton(context, state),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildVenueCount(state), _buildSortButton(context, state)],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildVenuesList(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, VenuesState state) {
    int totalFilters = 0;

    if (state is VenuesLoaded) {
      totalFilters =
          state.selectedFacilities.length + state.selectedFamilyAccess.length + state.selectedGuestAccess.length;
    } else if (state is VenuesLoadingMore) {
      totalFilters =
          state.selectedFacilities.length + state.selectedFamilyAccess.length + state.selectedGuestAccess.length;
    } else if (state is VenuesLoading && venuesBloc.state is VenuesLoaded) {
      final blocState = venuesBloc.state as VenuesLoaded;
      totalFilters =
          blocState.selectedFacilities.length +
          blocState.selectedFamilyAccess.length +
          blocState.selectedGuestAccess.length;
    }

    return Semantics(
      label: 'Filter venues',
      hint: totalFilters > 0 ? '$totalFilters filters applied' : 'No filters applied',
      button: true,
      child: ExcludeSemantics(
        child: Badge(
          isLabelVisible: totalFilters > 0,
          backgroundColor: Colors.grey,
          label: Text(
            totalFilters.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          child: IconButton(
            onPressed: () => _showFilterModal(context),
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2D3C4E)),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, VenuesState state) {
    String sortOrder = 'desc';
    if (state is VenuesLoaded) {
      sortOrder = state.sortOrder;
    }

    final sortLabel = sortOrder == 'asc' ? 'Oldest first' : 'Newest first';

    return Semantics(
      label: 'Sort order: $sortLabel',
      hint: 'Tap to change sort order',
      button: true,
      excludeSemantics: true,
      child: TextButton.icon(
        onPressed: () {
          context.read<VenuesBloc>().add(VenuesToggleSortOrderEvent());
        },
        icon: Icon(
          sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
          size: 18,
          color: const Color(0xFF2D3C4E),
        ),
        label: Text(sortLabel, style: const TextStyle(color: Color(0xFF2D3C4E))),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      ),
    );
  }

  Widget _buildVenueCount(VenuesState state) {
    if (state is VenuesLoaded) {
      int count = state.venues.length;
      String categoryName = state.selectedCategory;
      return Semantics(
        label: '$count $categoryName venues found',
        excludeSemantics: true,
        child: Text(
          '$count $categoryName venues',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
      );
    } else if (state is VenuesLoadingMore) {
      int count = state.currentVenues.length;
      String categoryName = state.selectedCategory;
      return Semantics(
        label: '$count $categoryName venues found',
        excludeSemantics: true,
        child: Text(
          '$count $categoryName venues',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVenuesList(VenuesState state) {
    if (state is VenuesLoading) {
      return const VenueScreenSkeleton();
    }

    if (state is VenuesLoaded) {
      return _buildPaginatedList(state.venues, state.hasReachedMax);
    }

    if (state is VenuesLoadingMore) {
      return _buildPaginatedList(state.currentVenues, false, isLoadingMore: true);
    }

    if (state is VenuesNoResults) {
      return NoResults(searchQuery: state.searchQuery);
    }

    if (state is VenuesError) {
      return Center(
        child: Semantics(
          label: 'Error loading venues',
          value: state.message,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: 'Retry loading venues',
                excludeSemantics: true,
                child: ElevatedButton.icon(
                  onPressed: () {
                    venuesBloc.add(const VenuesFetchEvent(resetFilters: false));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPaginatedList(List venues, bool hasReachedMax, {bool isLoadingMore = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          venuesBloc.add(const VenuesFetchEvent(resetFilters: false));
        },
        child:
            venues.isEmpty
                ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Center(child: Text('No venues found')),
                    ),
                  ],
                )
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: venues.length + (hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= venues.length) {
                      return isLoadingMore || (_isLoading && !hasReachedMax)
                          ? const VenueLoadingMoreIndicator()
                          : const SizedBox.shrink();
                    }
                    return VenueCard(venue: venues[index]);
                  },
                ),
      ),
    );
  }
}
