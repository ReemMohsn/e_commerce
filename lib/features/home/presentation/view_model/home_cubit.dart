import 'dart:async';

import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/home/data/repositories/home_repository.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeInitial());

  static const int pageSize = 10;

  final HomeRepository _repository;

  Future<void> fetchHomeData() async {
    if (state is HomeLoading) return;

    emit(const HomeLoading());

    try {
      final (categoriesResponse, productsResponse, brandsResponse) = await (
        _repository.getCategories(),
        _repository.getProducts(skip: 0, limit: pageSize),
        _repository.getBrands(),
      ).wait;
      final productsData = productsResponse.data;
      final products = productsData?.list ?? const <ProductModel>[];

      emit(
        HomeSuccess(
          categories: categoriesResponse.data ?? const [],
          products: products,
          filteredProducts: products,
          brands: brandsResponse.data ?? const [],
          nextSkip: productsData?.nextSkip ?? 0,
          hasMore: productsData?.hasMore ?? false,
        ),
      );
    } on ServerException catch (error) {
      emit(HomeFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        const HomeFailure(
          errorMessage: 'Unable to load home data. Please try again.',
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! HomeSuccess ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(
      currentState.copyWith(
        isLoadingMore: true,
        clearPaginationErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getProducts(
        skip: currentState.nextSkip,
        limit: pageSize,
      );
      final productsData = response.data;
      final incomingProducts = productsData?.list ?? const <ProductModel>[];

      final latestState = state;
      if (latestState is! HomeSuccess) return;

      final existingIds = latestState.products
          .map((product) => product.id)
          .toSet();
      final newProducts = incomingProducts
          .where((product) => existingIds.add(product.id))
          .toList(growable: false);
      final allProducts = [...latestState.products, ...newProducts];
      final filteredProducts = _filterProducts(
        products: allProducts,
        categorySlug: latestState.selectedCategorySlug,
        brandName: latestState.selectedBrandName,
      );

      emit(
        latestState.copyWith(
          products: allProducts,
          filteredProducts: filteredProducts,
          isLoadingMore: false,
          nextSkip: productsData?.nextSkip ?? latestState.nextSkip,
          hasMore: (productsData?.hasMore ?? false) && newProducts.isNotEmpty,
          clearPaginationErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      final latestState = state;
      if (latestState is! HomeSuccess) return;
      emit(
        latestState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage: error.message,
        ),
      );
    } catch (_) {
      final latestState = state;
      if (latestState is! HomeSuccess) return;
      emit(
        latestState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage:
              'Unable to load more products. Please try again.',
        ),
      );
    }
  }

  void filterByCategory(String? categorySlug) {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    final selectedCategory = _normalizeFilter(categorySlug);
    final filteredProducts = _filterProducts(
      products: currentState.products,
      categorySlug: selectedCategory,
      brandName: currentState.selectedBrandName,
    );

    emit(
      currentState.copyWith(
        filteredProducts: filteredProducts,
        selectedCategorySlug: selectedCategory,
        clearSelectedCategory: selectedCategory == null,
      ),
    );
  }

  void filterByBrand(String? brandName) {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    final selectedBrand = _normalizeFilter(brandName);
    final filteredProducts = _filterProducts(
      products: currentState.products,
      categorySlug: currentState.selectedCategorySlug,
      brandName: selectedBrand,
    );

    emit(
      currentState.copyWith(
        filteredProducts: filteredProducts,
        selectedBrandName: selectedBrand,
        clearSelectedBrand: selectedBrand == null,
      ),
    );
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is! HomeSuccess || !currentState.hasActiveFilters) return;

    emit(
      currentState.copyWith(
        filteredProducts: currentState.products,
        clearSelectedCategory: true,
        clearSelectedBrand: true,
      ),
    );
  }

  List<ProductModel> _filterProducts({
    required List<ProductModel> products,
    required String? categorySlug,
    required String? brandName,
  }) {
    if (categorySlug == null && brandName == null) return products;

    final normalizedCategory = categorySlug?.toLowerCase();
    final normalizedBrand = brandName?.toLowerCase();

    return products
        .where((product) {
          final matchesCategory =
              normalizedCategory == null ||
              product.category.trim().toLowerCase() == normalizedCategory;
          final matchesBrand =
              normalizedBrand == null ||
              product.brand.trim().toLowerCase() == normalizedBrand;

          return matchesCategory && matchesBrand;
        })
        .toList(growable: false);
  }

  String? _normalizeFilter(String? value) {
    final normalizedValue = value?.trim();
    return normalizedValue == null || normalizedValue.isEmpty
        ? null
        : normalizedValue;
  }

  Future<void> retryPagination() => loadMoreProducts();
}
