
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductsModel {
  String? id;
  String productName;
  double price;

  ProductsModel({
    this.id,
    required this.productName,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
    };
  }

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      productName: map['productName'] ?? '',
      price: map['price'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsModel.fromJson(String source) =>
      ProductsModel.fromMap(json.decode(source));
}
