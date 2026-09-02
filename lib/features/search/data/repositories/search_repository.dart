import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/products_response_model.dart';

class SearchRepository {
  const SearchRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<ProductsResponseModel>> searchProducts({
    required String search,
    required int skip,
    required int limit,
  }) {
    return RequestHandler<ProductsResponseModel>(
      () => _apiService.post(
        ApiEndPoints.productsFilter,
        data: {
          'skip': skip,
          'search': search,
          'brand': '',
          'category': '',
          'rating': '',
          'price': '',
          'discount': '',
          'popular': false,
          'limit': limit,
        },
      ),
      fromJson: (data) => ProductsResponseModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }
}
