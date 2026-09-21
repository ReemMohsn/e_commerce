class CategoryModel {
  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
    required this.image,
  });

  final String slug;
  final String name;
  final String url;
  final String image;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'slug': slug,
    'name': name,
    'url': url,
    'image': image,
  };
}
