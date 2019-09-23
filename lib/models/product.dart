import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  static int procuctCount;
  final String id;
  final String name;
  final int points;
  final double rating;
  final String image;

  Product({
    @required this.name,
    @required this.points,
    @required this.image,
    @required this.rating,
    @required this.id,
  }) {
    if (procuctCount == null) {
      procuctCount = 1;
    } else {
      procuctCount++;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
