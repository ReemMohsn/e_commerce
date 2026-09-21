import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/cart/data/repositories/cart_repository.dart';
import 'package:e_commeric/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(const CartInitial());

  final CartRepository _repository;

  Future<void> getCart() async {
    if (state is CartLoading) return;
    emit(const CartLoading());

    try {
      final response = await _repository.getCart();
      final products = response.data ?? const [];

      if (products.isEmpty) {
        emit(const CartEmpty());
        return;
      }

      emit(CartSuccess(products: products));
    } on ServerException catch (error) {
      emit(CartFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        const CartFailure(
          errorMessage: AppStrings.unableToLoadCartPleaseTryAgain,
        ),
      );
    }
  }

  Future<void> addToCart(int productId) async {
    if (state is AddCartLoading) return;
    emit(const AddCartLoading());

    try {
      final response = await _repository.addToCart(productId);
      final message = response.message;

      emit(AddCartSuccess(message: message));
    } on ServerException catch (error) {
      emit(AddCartFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        const AddCartFailure(
          errorMessage: AppStrings.unableToAddToCartPleaseTryAgain,
        ),
      );
    }
  }
}
