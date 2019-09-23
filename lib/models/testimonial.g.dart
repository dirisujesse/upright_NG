// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testimonial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Testimonial _$TestimonialFromJson(Map<String, dynamic> json) {
  return Testimonial(
      author: json['author'] as String,
      location: json['location'] as String,
      content: json['content'] as String,
      media: json['media'] as String,
      mediaType: json['mediaType'] as String);
}

Map<String, dynamic> _$TestimonialToJson(Testimonial instance) =>
    <String, dynamic>{
      'author': instance.author,
      'location': instance.location,
      'content': instance.content,
      'media': instance.media,
      'mediaType': instance.mediaType
    };
