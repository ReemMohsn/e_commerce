import 'package:e_commeric/features/home/data/models/brand_model.dart';
import 'package:e_commeric/features/home/data/models/category_model.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

enum HomeRequestStatus { initial, loading, success, failure }

@immutable
class HomeState {
  const HomeState({
    this.categoriesStatus = HomeRequestStatus.initial,
    this.productsStatus = HomeRequestStatus.initial,
    this.brandsStatus = HomeRequestStatus.initial,
    this.categories = const <CategoryModel>[],
    this.products = const <ProductModel>[],
    this.filteredProducts = const <ProductModel>[],
    this.brands = const <BrandModel>[],
    this.nextSkip = 0,
    this.hasMore = false,
    this.selectedCategorySlug,
    this.selectedBrandName,
    this.categoriesErrorMessage,
    this.productsErrorMessage,
    this.brandsErrorMessage,
    this.isLoadingMore = false,
    this.paginationErrorMessage,
  });

  final HomeRequestStatus categoriesStatus;
  final HomeRequestStatus productsStatus;
  final HomeRequestStatus brandsStatus;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final List<BrandModel> brands;
  final int nextSkip;
  final bool hasMore;
  final String? selectedCategorySlug;
  final String? selectedBrandName;
  final String? categoriesErrorMessage;
  final String? productsErrorMessage;
  final String? brandsErrorMessage;
  final bool isLoadingMore;
  final String? paginationErrorMessage;

  bool get hasActiveFilters =>
      selectedCategorySlug != null || selectedBrandName != null;

  HomeState copyWith({
    HomeRequestStatus? categoriesStatus,
    HomeRequestStatus? productsStatus,
    HomeRequestStatus? brandsStatus,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    List<BrandModel>? brands,
    int? nextSkip,
    bool? hasMore,
    String? selectedCategorySlug,
    bool clearSelectedCategory = false,
    String? selectedBrandName,
    bool clearSelectedBrand = false,
    String? categoriesErrorMessage,
    bool clearCategoriesErrorMessage = false,
    String? productsErrorMessage,
    bool clearProductsErrorMessage = false,
    String? brandsErrorMessage,
    bool clearBrandsErrorMessage = false,
    bool? isLoadingMore,
    String? paginationErrorMessage,
    bool clearPaginationErrorMessage = false,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      productsStatus: productsStatus ?? this.productsStatus,
      brandsStatus: brandsStatus ?? this.brandsStatus,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      brands: brands ?? this.brands,
      nextSkip: nextSkip ?? this.nextSkip,
      hasMore: hasMore ?? this.hasMore,
      selectedCategorySlug: clearSelectedCategory
          ? null
          : selectedCategorySlug ?? this.selectedCategorySlug,
      selectedBrandName: clearSelectedBrand
          ? null
          : selectedBrandName ?? this.selectedBrandName,
      categoriesErrorMessage: clearCategoriesErrorMessage
          ? null
          : categoriesErrorMessage ?? this.categoriesErrorMessage,
      productsErrorMessage: clearProductsErrorMessage
          ? null
          : productsErrorMessage ?? this.productsErrorMessage,
      brandsErrorMessage: clearBrandsErrorMessage
          ? null
          : brandsErrorMessage ?? this.brandsErrorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paginationErrorMessage: clearPaginationErrorMessage
          ? null
          : paginationErrorMessage ?? this.paginationErrorMessage,
    );
  }
}
