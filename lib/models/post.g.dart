// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      anonymous: json['anonymous'] as bool,
      body: json['body'] as String,
      featured: json['featured'] as bool,
      author: json['author'] == null
          ? null
          : User.fromJson(json['author'] as Map<String, dynamic>),
      hasVideo: json['hasVideo'] as bool,
      upvotes: json['upvotes'] as int,
      downvotes: json['downvotes'] as int,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      long: (json['long'] as num)?.toDouble(),
      lat: (json['lat'] as num)?.toDouble(),
      loc: json['loc'] as String,
      comments: (json['comments'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      fromTwitter: json['from_twitter'] as bool,
      subject: json['subject'] as List,
      image: json['image'] as String);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'anonymous': instance.anonymous,
      'body': instance.body,
      'featured': instance.featured,
      'author': instance.author,
      'hasVideo': instance.hasVideo,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'time': instance.time?.toIso8601String(),
      'long': instance.long,
      'lat': instance.lat,
      'loc': instance.loc,
      'comments': instance.comments,
      'from_twitter': instance.fromTwitter,
      'subject': instance.subject,
      'image': instance.image
    };
