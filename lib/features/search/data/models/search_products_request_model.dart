class SearchProductsRequestModel {
  const SearchProductsRequestModel({
    required this.search,
    required this.skip,
    required this.limit,
    this.brand = '',
    this.category = '',
    this.rating = '',
    this.price = '',
    this.discount = '',
    this.popular = false,
  });

  final String search;
  final int skip;
  final int limit;
  final String brand;
  final String category;
  final String rating;
  final String price;
  final String discount;
  final bool popular;

  Map<String, dynamic> toJson() => {
    'skip': skip,
    'search': search,
    'brand': brand,
    'category': category,
    'rating': rating,
    'price': price,
    'discount': discount,
    'popular': popular,
    'limit': limit,
  };
}
