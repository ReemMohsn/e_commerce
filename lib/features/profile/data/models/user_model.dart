class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.address,
  });

  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? address;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'image': image,
    'address': address,
  };
}
