// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      name: json['name'] as String,
      id: json['id'] as String,
      username: json['username'] as String,
      points: json['points'] as int,
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
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      isMember: json['isMember'] as bool,
      password: json['password'] as String,
      gender: json['gender'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'telephone': instance.telephone,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'avatar': instance.avatar,
      'posts': instance.posts,
      'postCount': instance.postCount,
      'points': instance.points,
      'comments': instance.comments,
      'email': instance.email,
      'isMember': instance.isMember,
      'password': instance.password,
      'gender': instance.gender
    };
