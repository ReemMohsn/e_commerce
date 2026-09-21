import 'package:e_commeric/features/home/data/models/product_model.dart';

class ProductsResponseModel {
  const ProductsResponseModel({
    required this.list,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductModel> list;
  final int total;
  final int skip;
  final int limit;

  int get nextSkip => skip + list.length;

  bool get hasMore => list.isNotEmpty && nextSkip < total;

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      list: (json['list'] as List)
          .map(
            (product) => ProductModel.fromJson(
              Map<String, dynamic>.from(product as Map),
            ),
          )
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'list': list.map((product) => product.toJson()).toList(),
    'total': total,
    'skip': skip,
    'limit': limit,
  };
}
