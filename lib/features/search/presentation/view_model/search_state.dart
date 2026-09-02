import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading({required this.query});

  final String query;
}

class SearchSuccess extends SearchState {
  const SearchSuccess({
    required this.products,
    required this.query,
    required this.nextSkip,
    required this.hasMore,
    this.isLoadingMore = false,
    this.paginationErrorMessage,
  });

  final List<ProductModel> products;
  final String query;
  final int nextSkip;
  final bool hasMore;
  final bool isLoadingMore;
  final String? paginationErrorMessage;

  SearchSuccess copyWith({
    List<ProductModel>? products,
    String? query,
    int? nextSkip,
    bool? hasMore,
    bool? isLoadingMore,
    String? paginationErrorMessage,
    bool clearPaginationErrorMessage = false,
  }) {
    return SearchSuccess(
      products: products ?? this.products,
      query: query ?? this.query,
      nextSkip: nextSkip ?? this.nextSkip,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paginationErrorMessage: clearPaginationErrorMessage
          ? null
          : paginationErrorMessage ?? this.paginationErrorMessage,
    );
  }
}

class SearchEmpty extends SearchState {
  const SearchEmpty({required this.query});

  final String query;
}

class SearchFailure extends SearchState {
  const SearchFailure({required this.query, required this.errorMessage});

  final String query;
  final String errorMessage;
}
