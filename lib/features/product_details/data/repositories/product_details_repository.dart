import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/product_model.dart';

class ProductDetailsRepository {
  const ProductDetailsRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<ProductModel>> getProductDetails(int productId) {
    return RequestHandler<ProductModel>(
      () => _apiService.get(ApiEndPoints.productDetails(productId)),
      fromJson: (data) =>
          ProductModel.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }
}
