import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/products_response_model.dart';
import 'package:e_commeric/features/search/data/models/search_products_request_model.dart';

class SearchRepository {
  const SearchRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<ProductsResponseModel>> searchProducts(
    SearchProductsRequestModel request,
  ) {
    return RequestHandler<ProductsResponseModel>(
      () => _apiService.post(
        ApiEndPoints.productsFilter,
        data: request.toJson(),
      ),
      fromJson: (data) =>
          ProductsResponseModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
