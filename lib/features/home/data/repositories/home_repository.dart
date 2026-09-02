import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/features/home/data/models/brand_model.dart';
import 'package:e_commeric/features/home/data/models/category_model.dart';
import 'package:e_commeric/features/home/data/models/products_response_model.dart';

class HomeRepository {
  const HomeRepository({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  Future<ApiResponse<List<CategoryModel>>> getCategories() {
    return RequestHandler<List<CategoryModel>>(
      () => _apiService.get(ApiEndPoints.homeCategories),
      fromJson: (data) {
        final json = Map<String, dynamic>.from(data as Map);
        return (json['list'] as List)
            .map(
              (category) => CategoryModel.fromJson(
                Map<String, dynamic>.from(category as Map),
              ),
            )
            .toList();
      },
    );
  }

  Future<ApiResponse<ProductsResponseModel>> getProducts({
    required int skip,
    required int limit,
  }) {
    return RequestHandler<ProductsResponseModel>(
      () => _apiService.get(
        ApiEndPoints.homeProducts,
        queryParameters: {'skip': skip, 'limit': limit},
      ),
      fromJson: (data) => ProductsResponseModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  Future<ApiResponse<List<BrandModel>>> getBrands() {
    return RequestHandler<List<BrandModel>>(
      () => _apiService.get(ApiEndPoints.homeBrands),
      fromJson: (data) {
        final json = Map<String, dynamic>.from(data as Map);
        return (json['list'] as List)
            .map(
              (brand) =>
                  BrandModel.fromJson(Map<String, dynamic>.from(brand as Map)),
            )
            .toList();
      },
    );
  }
}
