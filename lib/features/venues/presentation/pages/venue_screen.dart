import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/bloc/venues_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/extensions/venues_state_extension.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/filter_bloc/filter_event.dart';
import 'package:hotel_list_app/features/venues/presentation/widgets/index.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  State<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  late final VenuesBloc _venuesBloc;
  late final FilterBloc _filterBloc;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  static const _primaryTextColor = Color(0xFF2D3C4E);
  static const _horizontalPadding = EdgeInsets.symmetric(horizontal: 16.0);

  @override
  void initState() {
    super.initState();
    _venuesBloc = VenuesBloc()..add(const VenuesFetchEvent(resetFilters: true));
    _filterBloc = FilterBloc()..add(FilterFetchEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _venuesBloc.close();
    _filterBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isLoading && _venuesBloc.state is VenuesLoaded) {
      final state = _venuesBloc.state as VenuesLoaded;
      if (!state.hasReachedMax) {
        setState(() => _isLoading = true);
        _venuesBloc.add(VenuesFetchNextPageEvent(page: state.currentPage + 1));
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
              BlocProvider<VenuesBloc>.value(value: _venuesBloc),
              BlocProvider<FilterBloc>.value(value: _filterBloc),
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
          style: TextStyle(color: _primaryTextColor, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<VenuesBloc>.value(value: _venuesBloc),
          BlocProvider<FilterBloc>.value(value: _filterBloc),
        ],
        child: BlocConsumer<VenuesBloc, VenuesState>(
          listener: (context, state) {
            if (state is VenuesLoaded || state is VenuesError || state is VenuesNoResults) {
              setState(() => _isLoading = false);
            }
          },
          builder:
              (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FilterChipsRow(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: _horizontalPadding,
                    child: Row(
                      children: [
                        Expanded(child: SearchBarWidget(initialQuery: state.searchQuery)),
                        const SizedBox(width: 8),
                        FilterButton(state: state, onPressed: () => _showFilterModal(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: _horizontalPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [VenueCount(state: state), SortButton(state: state)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildVenuesList(state)),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildVenuesList(VenuesState state) {
    if (state is VenuesLoading) {
      return const VenueScreenSkeleton();
    }

    if (state is VenuesLoaded) {
      return PaginatedVenueList(
        venues: state.venues,
        hasReachedMax: state.hasReachedMax,
        isLoading: _isLoading,
        scrollController: _scrollController,
        padding: _horizontalPadding,
        onRefresh: () => _venuesBloc.add(const VenuesFetchEvent(resetFilters: false)),
      );
    }

    if (state is VenuesLoadingMore) {
      return PaginatedVenueList(
        venues: state.currentVenues,
        hasReachedMax: false,
        isLoadingMore: true,
        isLoading: _isLoading,
        scrollController: _scrollController,
        padding: _horizontalPadding,
        onRefresh: () => _venuesBloc.add(const VenuesFetchEvent(resetFilters: false)),
      );
    }

    if (state is VenuesNoResults) {
      return NoResults(searchQuery: state.searchQuery);
    }

    if (state is VenuesError) {
      return ErrorView(state: state, onRetry: () => _venuesBloc.add(const VenuesFetchEvent(resetFilters: false)));
    }

    return const SizedBox.shrink();
  }
}
