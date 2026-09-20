import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class FavoriteState {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteStatusUpdated extends FavoriteState {
  const FavoriteStatusUpdated();
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

class FavoriteEmpty extends FavoriteState {
  const FavoriteEmpty();
}

class FavoriteSuccess extends FavoriteState {
  const FavoriteSuccess({
    required this.products,
    required this.nextSkip,
    required this.hasMore,
    this.isLoadingMore = false,
    this.paginationErrorMessage,
  });

  final List<ProductModel> products;
  final int nextSkip;
  final bool hasMore;
  final bool isLoadingMore;
  final String? paginationErrorMessage;

  FavoriteSuccess copyWith({
    List<ProductModel>? products,
    int? nextSkip,
    bool? hasMore,
    bool? isLoadingMore,
    String? paginationErrorMessage,
    bool clearPaginationErrorMessage = false,
  }) {
    return FavoriteSuccess(
      products: products ?? this.products,
      nextSkip: nextSkip ?? this.nextSkip,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paginationErrorMessage: clearPaginationErrorMessage
          ? null
          : paginationErrorMessage ?? this.paginationErrorMessage,
    );
  }
}

class FavoriteFailure extends FavoriteState {
  const FavoriteFailure({required this.errorMessage});

  final String errorMessage;
}

class AddFavoriteLoading extends FavoriteState {
  const AddFavoriteLoading({required this.productId});

  final int productId;
}

class AddFavoriteSuccess extends FavoriteState {
  const AddFavoriteSuccess({required this.productId, required this.message});

  final int productId;
  final String message;
}

class AddFavoriteFailure extends FavoriteState {
  const AddFavoriteFailure({
    required this.productId,
    required this.errorMessage,
  });

  final int productId;
  final String errorMessage;
}

class DeleteFavoriteLoading extends FavoriteState {
  const DeleteFavoriteLoading({required this.productId});

  final int productId;
}

class DeleteFavoriteSuccess extends FavoriteState {
  const DeleteFavoriteSuccess({required this.productId, required this.message});

  final int productId;
  final String message;
}

class DeleteFavoriteFailure extends FavoriteState {
  const DeleteFavoriteFailure({
    required this.productId,
    required this.errorMessage,
  });

  final int productId;
  final String errorMessage;
}
