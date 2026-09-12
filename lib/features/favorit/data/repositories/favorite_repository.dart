import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/products_response_model.dart';

class FavoriteRepository {
  const FavoriteRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<Object?>> addToFavorite(int productId) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.addFavorite,
        data: {'productId': productId},
      ),
    );
  }

  Future<ApiResponse<ProductsResponseModel>> getFavorite({
    required int skip,
    required int limit,
  }) {
    return RequestHandler<ProductsResponseModel>(
      () => _apiService.get(
        ApiEndPoints.getFavorite,
        queryParameters: {'skip': skip, 'limit': limit},
      ),
      fromJson: (data) {
        final json = data as Map<String, dynamic>;
        final favoriteData = json['list'] as List;

        if (favoriteData.isEmpty) {
          return ProductsResponseModel(
            list: const [],
            total: 0,
            skip: skip,
            limit: limit,
          );
        }

        return ProductsResponseModel.fromJson(
          favoriteData.first as Map<String, dynamic>,
        );
      },
    );
  }

  Future<ApiResponse<Object?>> deleteFavorite(int productId) {
    return RequestHandler<Object?>(
      () => _apiService.delete(
        ApiEndPoints.deleteFavorite,
        data: {'productId': productId},
      ),
    );
  }
}
