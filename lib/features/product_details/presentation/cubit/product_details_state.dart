import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ProductDetailsState {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsSuccess extends ProductDetailsState {
  const ProductDetailsSuccess({
    required this.product,
    this.selectedImageIndex = 0,
  });

  final ProductModel product;
  final int selectedImageIndex;

  ProductDetailsSuccess copyWith({
    ProductModel? product,
    int? selectedImageIndex,
  }) {
    return ProductDetailsSuccess(
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}

class ProductDetailsFailure extends ProductDetailsState {
  const ProductDetailsFailure({required this.errorMessage});

  final String errorMessage;
}
