// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      id: json['id'] as String,
      body: json['body'] as String,
      author: json['author'] == null
          ? null
          : User.fromJson(json['author'] as Map<String, dynamic>),
      post: json['post'] as String,
      comment: json['comment'] == null
          ? null
          : Comment.fromJson(json['comment'] as Map<String, dynamic>),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      replies: json['replies'] == null
          ? null
          : Comment.fromJson(json['replies'] as Map<String, dynamic>),
      upvotes: json['upvotes'] as int,
      downvotes: json['downvotes'] as int);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'author': instance.author,
      'post': instance.post,
      'comment': instance.comment,
      'time': instance.time?.toIso8601String(),
      'replies': instance.replies,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes
    };
