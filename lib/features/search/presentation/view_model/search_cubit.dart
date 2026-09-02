import 'dart:async';

import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/search/data/repositories/search_repository.dart';
import 'package:e_commeric/features/search/presentation/view_model/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchInitial());

  static const int pageSize = 10;
  static const Duration debounceDuration = Duration(milliseconds: 500);

  final SearchRepository _repository;

  Timer? _debounce;
  String _currentQuery = '';
  int _searchVersion = 0;

  void onSearchChanged(String value) {
    final query = value.trim();
    _currentQuery = query;
    _searchVersion++;
    _debounce?.cancel();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    final version = _searchVersion;
    _debounce = Timer(
      debounceDuration,
      () => _searchProducts(query: query, version: version),
    );
  }

  Future<void> submitSearch(String value) async {
    final query = value.trim();
    _currentQuery = query;
    _searchVersion++;
    _debounce?.cancel();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    await _searchProducts(query: query, version: _searchVersion);
  }

  Future<void> _searchProducts({
    required String query,
    required int version,
  }) async {
    emit(SearchLoading(query: query));

    try {
      final response = await _repository.searchProducts(
        search: query,
        skip: 0,
        limit: pageSize,
      );

      if (isClosed || version != _searchVersion) return;

      final productsData = response.data;
      final products = productsData?.list ?? const <ProductModel>[];

      if (products.isEmpty) {
        emit(SearchEmpty(query: query));
        return;
      }

      emit(
        SearchSuccess(
          products: products,
          query: query,
          nextSkip: productsData?.nextSkip ?? 0,
          hasMore: productsData?.hasMore ?? false,
        ),
      );
    } on ServerException catch (error) {
      if (isClosed || version != _searchVersion) return;
      emit(SearchFailure(query: query, errorMessage: error.message));
    } catch (_) {
      if (isClosed || version != _searchVersion) return;
      emit(
        SearchFailure(
          query: query,
          errorMessage: 'Unable to search products. Please try again.',
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! SearchSuccess ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    final version = _searchVersion;
    emit(
      currentState.copyWith(
        isLoadingMore: true,
        clearPaginationErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.searchProducts(
        search: currentState.query,
        skip: currentState.nextSkip,
        limit: pageSize,
      );

      if (isClosed || version != _searchVersion) return;

      final productsData = response.data;
      final incomingProducts = productsData?.list ?? const <ProductModel>[];
      final existingIds = currentState.products
          .map((product) => product.id)
          .toSet();
      final newProducts = incomingProducts
          .where((product) => existingIds.add(product.id))
          .toList(growable: false);

      emit(
        currentState.copyWith(
          products: [...currentState.products, ...newProducts],
          nextSkip: productsData?.nextSkip ?? currentState.nextSkip,
          hasMore: (productsData?.hasMore ?? false) && newProducts.isNotEmpty,
          isLoadingMore: false,
          clearPaginationErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      if (isClosed || version != _searchVersion) return;
      emit(
        currentState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage: error.message,
        ),
      );
    } catch (_) {
      if (isClosed || version != _searchVersion) return;
      emit(
        currentState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage:
              'Unable to load more products. Please try again.',
        ),
      );
    }
  }

  Future<void> retrySearch() => submitSearch(_currentQuery);

  Future<void> retryPagination() => loadMoreProducts();

  @override
  Future<void> close() {
    _searchVersion++;
    _debounce?.cancel();
    return super.close();
  }
}
