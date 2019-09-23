// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      eDD: json['eDD'] as int,
      purchaser: json['purchaser'] == null
          ? null
          : User.fromJson(json['purchaser'] as Map<String, dynamic>),
      hasBeenDelivered: json['hasBeenDelivered'] as bool,
      id: json['id'] as String,
      deliveryDate: json['deliveryDate'] as String,
      createdAt: json['createdAt'] as String,
      pickupLocation: json['pickupLocation'] as String);
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'product': instance.product,
      'purchaser': instance.purchaser,
      'hasBeenDelivered': instance.hasBeenDelivered,
      'deliveryDate': instance.deliveryDate,
      'createdAt': instance.createdAt,
      'eDD': instance.eDD,
      'id': instance.id,
      'pickupLocation': instance.pickupLocation
    };
