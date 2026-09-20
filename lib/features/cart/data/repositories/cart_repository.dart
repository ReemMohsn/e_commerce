import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';

class CartRepository {
  const CartRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<Object?>> addToCart(int productId) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.addCart,
        data: {'productId': productId},
      ),
    );
  }

  Future<ApiResponse<List<ProductModel>>> getCart() {
    return RequestHandler<List<ProductModel>>(
      () => _apiService.get(ApiEndPoints.getCart),
      fromJson: (data) {
        final json = data as Map<String, dynamic>;
        final products = json['list'] as List;
        return products
            .map(
              (product) => ProductModel.fromJson(
                Map<String, dynamic>.from(product as Map),
              ),
            )
            .toList();
      },
    );
  }
}
