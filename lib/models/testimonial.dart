import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'testimonial.g.dart';

@JsonSerializable()
class Testimonial {
  final String author;
  final String location;
  final String content;
  final String media;
  final String mediaType;

  Testimonial({
    @required this.author,
    @required this.location,
    @required this.content,
    @required this.media,
    @required this.mediaType,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) => _$TestimonialFromJson(json);
  Map<String, dynamic> toJson() => _$TestimonialToJson(this);
}
