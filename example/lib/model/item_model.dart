class Item {
  final int productId;
  final String name;
  final String unit;
  final int price;
  final String image;

  Item(
      {required this.productId,
      required this.name,
      required this.unit,
      required this.price,
      required this.image});

  Map toJson() {
    return {
      'product_id': productId,
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }
}
