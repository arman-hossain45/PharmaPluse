class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final int stock;
  final String category;
  final String? dosage;
  final bool prescriptionRequired;
  final String? manufacturer;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.stock,
    required this.category,
    this.dosage,
    this.prescriptionRequired = false,
    this.manufacturer,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? description,
    int? stock,
    String? category,
    String? dosage,
    bool? prescriptionRequired,
    String? manufacturer,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      dosage: dosage ?? this.dosage,
      prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
      manufacturer: manufacturer ?? this.manufacturer,
    );
  }
}