import 'package:Upright_NG/models/product.dart';
import 'package:Upright_NG/models/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final Product product;
  final User purchaser;
  final bool hasBeenDelivered;
  final String deliveryDate;
  final String createdAt;
  final int eDD;
  final String id;
  String pickupLocation;

  Order({
    @required this.product,
    @required this.eDD,
    @required this.purchaser,
    this.hasBeenDelivered,
    this.id,
    this.deliveryDate,
    this.createdAt,
    this.pickupLocation = "CCSI 16b, P.O.W Mafemi Crescent,Utako, Abuja, Mobile: 09022210504"
  });

  Map<String, dynamic> toJson() {
    return {
      "product": product.id,
      "EDD": eDD,
      "purchaser": purchaser.id,
      "hasBeenDelivered": false,
      "pickupLocation": pickupLocation
    };
  }

  static Order fromJson(Map<String, dynamic> map) {
    return Order(
      product: Product.fromJson(map["product"]),
      eDD: map["EDD"],
      purchaser: User.fromJson(map["purchaser"]),
      hasBeenDelivered: map["hasBeenDelivered"],
      deliveryDate: map["deliveryDate"],
      createdAt: map["createdAt"],
      id: map["id"],
      pickupLocation: map["pickupLocation"]
    );
  }
}