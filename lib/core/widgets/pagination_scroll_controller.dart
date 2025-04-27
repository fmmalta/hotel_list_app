import 'package:flutter/material.dart';

typedef LoadMoreCallback = Future<void> Function(int page);

class PaginationScrollController extends ScrollController {
  final LoadMoreCallback onLoadMore;
  final double loadTriggerThreshold;
  final bool hasReachedMax;

  bool _isLoadingMore = false;
  int _currentPage = 1;

  PaginationScrollController({
    required this.onLoadMore,
    this.loadTriggerThreshold = 0.8,
    this.hasReachedMax = false,
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  }) {
    addListener(_scrollListener);
  }

  int get currentPage => _currentPage;
  bool get isLoadingMore => _isLoadingMore;

  void _scrollListener() {
    if (_isBottom && !_isLoadingMore && !hasReachedMax) {
      _loadNextPage();
    }
  }

  bool get _isBottom {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = offset;
    return currentScroll >= (maxScroll * loadTriggerThreshold);
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    try {
      await onLoadMore(_currentPage + 1);
      _currentPage++;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _isLoadingMore = false;
    try {
      await onLoadMore(1);
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    removeListener(_scrollListener);
    super.dispose();
  }
}
