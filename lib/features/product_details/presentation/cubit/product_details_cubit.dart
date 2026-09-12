import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/product_details/data/repositories/product_details_repository.dart';
import 'package:e_commeric/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._repository) : super(const ProductDetailsInitial());

  final ProductDetailsRepository _repository;
  int? _productId;

  Future<void> fetchProduct(int productId) async {
    if (state is ProductDetailsLoading) return;
    _productId = productId;
    emit(const ProductDetailsLoading());

    try {
      final response = await _repository.getProductDetails(productId);
      final product = response.data;

      if (product == null) {
        emit(
          const ProductDetailsFailure(
            errorMessage: 'Product details are not available.',
          ),
        );
        return;
      }

      emit(ProductDetailsSuccess(product: product));
    } on ServerException catch (error) {
      emit(ProductDetailsFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        const ProductDetailsFailure(
          errorMessage: 'Unable to load product details. Please try again.',
        ),
      );
    }
  }

  Future<void> retry() async {
    final productId = _productId;
    if (productId != null) await fetchProduct(productId);
  }

  void selectImage(int index) {
    final currentState = state;
    if (currentState is! ProductDetailsSuccess) return;
    if (index < 0 || index >= currentState.product.images.length) return;
    if (currentState.selectedImageIndex == index) return;

    emit(currentState.copyWith(selectedImageIndex: index));
  }
}
