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
    required this.quantity,
    this.selectedImageIndex = 0,
    this.isFavorite = false,
  });

  final ProductModel product;
  final int selectedImageIndex;
  final int quantity;
  final bool isFavorite;

  bool get canDecreaseQuantity => quantity > product.minimumOrderQuantity;

  bool get canIncreaseQuantity => quantity < product.stock;

  ProductDetailsSuccess copyWith({
    ProductModel? product,
    int? selectedImageIndex,
    int? quantity,
    bool? isFavorite,
  }) {
    return ProductDetailsSuccess(
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProductDetailsFailure extends ProductDetailsState {
  const ProductDetailsFailure({required this.errorMessage});

  final String errorMessage;
}
