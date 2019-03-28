// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      name: json['name'] as String,
      username: json['username'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      avatar: json['avatar'] as String,
      posts: (json['posts'] as List)
          ?.map((e) =>
              e == null ? null : Post.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      postCount: json['postCount'] as int,
      comments: (json['comments'] as List)
          ?.map((e) =>
              e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      email: json['email'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'avatar': instance.avatar,
      'posts': instance.posts,
      'postCount': instance.postCount,
      'comments': instance.comments,
      'email': instance.email
    };
