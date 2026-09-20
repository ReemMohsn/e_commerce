import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartSuccess extends CartState {
  const CartSuccess({required this.products});

  final List<ProductModel> products;
}

class CartFailure extends CartState {
  const CartFailure({required this.errorMessage});

  final String errorMessage;
}

class AddCartLoading extends CartState {
  const AddCartLoading();
}

class AddCartSuccess extends CartState {
  const AddCartSuccess({required this.message});

  final String message;
}

class AddCartFailure extends CartState {
  const AddCartFailure({required this.errorMessage});

  final String errorMessage;
}
