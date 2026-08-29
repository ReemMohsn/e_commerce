class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final ProductDimensionsModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ProductMetaModel meta;
  final List<String> images;
  final String thumbnail;

  double get priceAfterDiscount {
    return price - (price * discountPercentage / 100);
  }

  bool get hasDiscount => discountPercentage > 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] as List),
      brand: json['brand'] as String,
      sku: json['sku'] as String,
      weight: json['weight'] as int,
      dimensions: ProductDimensionsModel.fromJson(
        Map<String, dynamic>.from(json['dimensions'] as Map),
      ),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews: (json['reviews'] as List)
          .map(
            (review) => ProductReviewModel.fromJson(
              Map<String, dynamic>.from(review as Map),
            ),
          )
          .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: ProductMetaModel.fromJson(
        Map<String, dynamic>.from(json['meta'] as Map),
      ),
      images: List<String>.from(json['images'] as List),
      thumbnail: json['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'brand': brand,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions.toJson(),
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'availabilityStatus': availabilityStatus,
    'reviews': reviews.map((review) => review.toJson()).toList(),
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'meta': meta.toJson(),
    'images': images,
    'thumbnail': thumbnail,
  };
}

class ProductDimensionsModel {
  const ProductDimensionsModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  factory ProductDimensionsModel.fromJson(Map<String, dynamic> json) {
    return ProductDimensionsModel(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'depth': depth,
  };
}

class ProductReviewModel {
  const ProductReviewModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      date: json['date'] as String,
      reviewerName: json['reviewerName'] as String,
      reviewerEmail: json['reviewerEmail'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'date': date,
    'reviewerName': reviewerName,
    'reviewerEmail': reviewerEmail,
  };
}

class ProductMetaModel {
  const ProductMetaModel({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  factory ProductMetaModel.fromJson(Map<String, dynamic> json) {
    return ProductMetaModel(
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      barcode: json['barcode'] as String,
      qrCode: json['qrCode'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'barcode': barcode,
    'qrCode': qrCode,
  };
}
