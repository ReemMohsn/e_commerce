import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:e_commeric/features/home/data/repositories/home_repository.dart';
import 'package:e_commeric/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  static const int pageSize = 10;

  final HomeRepository _repository;

  Future<void> fetchCategories() async {
    if (state.categoriesStatus == HomeRequestStatus.loading) return;

    emit(
      state.copyWith(
        categoriesStatus: HomeRequestStatus.loading,
        clearCategoriesErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getCategories();

      emit(
        state.copyWith(
          categoriesStatus: HomeRequestStatus.success,
          categories: response.data ?? const [],
          clearCategoriesErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          categoriesStatus: HomeRequestStatus.failure,
          categoriesErrorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          categoriesStatus: HomeRequestStatus.failure,
          categoriesErrorMessage:
              'Unable to load categories. Please try again.',
        ),
      );
    }
  }

  Future<void> fetchProducts() async {
    if (state.productsStatus == HomeRequestStatus.loading ||
        state.isLoadingMore) {
      return;
    }

    emit(
      state.copyWith(
        productsStatus: HomeRequestStatus.loading,
        isLoadingMore: false,
        clearProductsErrorMessage: true,
        clearPaginationErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getProducts(skip: 0, limit: pageSize);
      final productsData = response.data;
      final products = productsData?.list ?? const <ProductModel>[];
      final filteredProducts = _filterProducts(
        products: products,
        categorySlug: state.selectedCategorySlug,
        brandName: state.selectedBrandName,
      );

      emit(
        state.copyWith(
          productsStatus: HomeRequestStatus.success,
          products: products,
          filteredProducts: filteredProducts,
          nextSkip: productsData?.nextSkip ?? 0,
          hasMore: productsData?.hasMore ?? false,
          clearProductsErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          productsStatus: HomeRequestStatus.failure,
          productsErrorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          productsStatus: HomeRequestStatus.failure,
          productsErrorMessage: 'Unable to load products. Please try again.',
        ),
      );
    }
  }

  Future<void> fetchBrands() async {
    if (state.brandsStatus == HomeRequestStatus.loading) return;

    emit(
      state.copyWith(
        brandsStatus: HomeRequestStatus.loading,
        clearBrandsErrorMessage: true,
      ),
    );

    try {
      final response = await _repository.getBrands();

      emit(
        state.copyWith(
          brandsStatus: HomeRequestStatus.success,
          brands: response.data ?? const [],
          clearBrandsErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          brandsStatus: HomeRequestStatus.failure,
          brandsErrorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          brandsStatus: HomeRequestStatus.failure,
          brandsErrorMessage: 'Unable to load brands. Please try again.',
        ),
      );
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState.productsStatus != HomeRequestStatus.success ||
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
      if (latestState.productsStatus != HomeRequestStatus.success) return;

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
      if (latestState.productsStatus != HomeRequestStatus.success) return;
      emit(
        latestState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage: error.message,
        ),
      );
    } catch (_) {
      final latestState = state;
      if (latestState.productsStatus != HomeRequestStatus.success) return;
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
    if (currentState.productsStatus != HomeRequestStatus.success) return;

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
    if (currentState.productsStatus != HomeRequestStatus.success) return;

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
    if (currentState.productsStatus != HomeRequestStatus.success ||
        !currentState.hasActiveFilters) {
      return;
    }

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
