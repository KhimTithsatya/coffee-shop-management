class Product {
  final int? id;
  final String name;
  final String category;
  final double price;
  final bool active;

  const Product({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.active = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'Other',
      price: (json['price'] as num).toDouble(),
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'price': price,
        'active': active,
      };
}
