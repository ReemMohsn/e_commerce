import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/services/errors/exception.dart';
import 'package:e_commeric/features/favorit/data/repositories/favorite_repository.dart';
import 'package:e_commeric/features/favorit/presentation/view_model/favorite_state.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit(this._repository) : super(const FavoriteInitial());

  static const int pageSize = 10;
  static const int favoriteLookupLimit = 1000;

  final FavoriteRepository _repository;
  final Set<int> _favoriteProductIds = <int>{};
  bool _isUpdatingFavorite = false;
  bool _isLoadingFavoriteStatus = false;

  bool isFavorite(int productId) => _favoriteProductIds.contains(productId);

  Future<void> loadFavoriteStatus() async {
    if (_isLoadingFavoriteStatus) return;
    _isLoadingFavoriteStatus = true;

    try {
      final response = await _repository.getFavorite(
        skip: 0,
        limit: favoriteLookupLimit,
      );
      final products = response.data?.list ?? const <ProductModel>[];

      _favoriteProductIds
        ..clear()
        ..addAll(products.map((product) => product.id));

      final currentState = state;
      if (currentState is AddFavoriteSuccess) {
        _favoriteProductIds.add(currentState.productId);
      } else if (currentState is DeleteFavoriteSuccess) {
        _favoriteProductIds.remove(currentState.productId);
      }

      if (currentState is FavoriteSuccess) {
        emit(currentState.copyWith());
      } else if (currentState is! FavoriteLoading &&
          currentState is! AddFavoriteLoading &&
          currentState is! DeleteFavoriteLoading) {
        emit(const FavoriteStatusUpdated());
      }
    } catch (_) {
      // The products remain usable even when favorite status cannot be loaded.
    } finally {
      _isLoadingFavoriteStatus = false;
    }
  }

  Future<void> getFavorite() async {
    if (state is FavoriteLoading) return;
    emit(const FavoriteLoading());

    try {
      final response = await _repository.getFavorite(skip: 0, limit: pageSize);
      final favoriteData = response.data;
      final products = favoriteData?.list ?? const <ProductModel>[];

      _favoriteProductIds.addAll(products.map((product) => product.id));

      if (products.isEmpty) {
        emit(const FavoriteEmpty());
        return;
      }

      emit(
        FavoriteSuccess(
          products: products,
          nextSkip: favoriteData?.nextSkip ?? 0,
          hasMore: favoriteData?.hasMore ?? false,
        ),
      );
    } on ServerException catch (error) {
      emit(FavoriteFailure(errorMessage: error.message));
    } catch (_) {
      emit(
        const FavoriteFailure(
          errorMessage: AppStrings.unableToLoadFavoritesPleaseTryAgain,
        ),
      );
    }
  }

  Future<void> loadMoreFavorite() async {
    final currentState = state;
    if (currentState is! FavoriteSuccess ||
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
      final response = await _repository.getFavorite(
        skip: currentState.nextSkip,
        limit: pageSize,
      );
      final favoriteData = response.data;
      final incomingProducts = favoriteData?.list ?? const <ProductModel>[];

      _favoriteProductIds.addAll(incomingProducts.map((product) => product.id));

      final latestState = state;
      if (latestState is! FavoriteSuccess) return;

      final existingIds = latestState.products
          .map((product) => product.id)
          .toSet();
      final newProducts = incomingProducts
          .where((product) => existingIds.add(product.id))
          .toList(growable: false);

      emit(
        latestState.copyWith(
          products: [...latestState.products, ...newProducts],
          nextSkip: favoriteData?.nextSkip ?? latestState.nextSkip,
          hasMore: (favoriteData?.hasMore ?? false) && newProducts.isNotEmpty,
          isLoadingMore: false,
          clearPaginationErrorMessage: true,
        ),
      );
    } on ServerException catch (error) {
      final latestState = state;
      if (latestState is! FavoriteSuccess) return;
      emit(
        latestState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage: error.message,
        ),
      );
    } catch (_) {
      final latestState = state;
      if (latestState is! FavoriteSuccess) return;
      emit(
        latestState.copyWith(
          isLoadingMore: false,
          paginationErrorMessage:
              AppStrings.unableToLoadMoreFavoritesPleaseTryAgain,
        ),
      );
    }
  }

  Future<void> retryPagination() => loadMoreFavorite();

  Future<void> toggleFavorite(int productId) {
    return isFavorite(productId)
        ? deleteFavorite(productId)
        : addToFavorite(productId);
  }

  Future<void> addToFavorite(int productId) async {
    if (_isUpdatingFavorite) return;
    _isUpdatingFavorite = true;
    emit(AddFavoriteLoading(productId: productId));

    try {
      final response = await _repository.addToFavorite(productId);
      _favoriteProductIds.add(productId);
      emit(AddFavoriteSuccess(productId: productId, message: response.message));
    } on ServerException catch (error) {
      emit(
        AddFavoriteFailure(productId: productId, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        AddFavoriteFailure(
          productId: productId,
          errorMessage: AppStrings.unableToAddToFavoritesPleaseTryAgain,
        ),
      );
    } finally {
      _isUpdatingFavorite = false;
    }
  }

  Future<void> deleteFavorite(int productId) async {
    final currentState = state;
    if (_isUpdatingFavorite ||
        currentState is FavoriteSuccess && currentState.isLoadingMore) {
      return;
    }
    _isUpdatingFavorite = true;
    emit(DeleteFavoriteLoading(productId: productId));

    try {
      final response = await _repository.deleteFavorite(productId);
      _favoriteProductIds.remove(productId);
      emit(
        DeleteFavoriteSuccess(productId: productId, message: response.message),
      );
    } on ServerException catch (error) {
      emit(
        DeleteFavoriteFailure(
          productId: productId,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        DeleteFavoriteFailure(
          productId: productId,
          errorMessage: AppStrings.unableToDeleteFromFavoritesPleaseTryAgain,
        ),
      );
    } finally {
      _isUpdatingFavorite = false;
    }
  }
}
