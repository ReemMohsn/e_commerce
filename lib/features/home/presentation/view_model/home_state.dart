import 'package:e_commeric/features/home/data/models/brand_model.dart';
import 'package:e_commeric/features/home/data/models/category_model.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.categories,
    required this.products,
    required this.filteredProducts,
    required this.brands,
    required this.nextSkip,
    required this.hasMore,
    this.selectedCategorySlug,
    this.selectedBrandName,
    this.isLoadingMore = false,
    this.paginationErrorMessage,
  });

  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final List<BrandModel> brands;
  final int nextSkip;
  final bool hasMore;
  final String? selectedCategorySlug;
  final String? selectedBrandName;
  final bool isLoadingMore;
  final String? paginationErrorMessage;

  bool get hasHomeData =>
      categories.isNotEmpty || products.isNotEmpty || brands.isNotEmpty;

  bool get hasActiveFilters =>
      selectedCategorySlug != null || selectedBrandName != null;

  HomeSuccess copyWith({
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
    bool? isLoadingMore,
    String? paginationErrorMessage,
    bool clearPaginationErrorMessage = false,
  }) {
    return HomeSuccess(
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
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paginationErrorMessage: clearPaginationErrorMessage
          ? null
          : paginationErrorMessage ?? this.paginationErrorMessage,
    );
  }
}

class HomeFailure extends HomeState {
  const HomeFailure({required this.errorMessage});

  final String errorMessage;
}
