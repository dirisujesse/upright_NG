// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
      name: json['name'] as String,
      points: json['points'] as int,
      image: json['image'] as String,
      rating: (json['rating'] as num)?.toDouble(),
      id: json['id'] as String);
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'points': instance.points,
      'rating': instance.rating,
      'image': instance.image
    };
