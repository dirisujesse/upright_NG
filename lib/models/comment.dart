import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'comment.g.dart';
// import '../services/storage_service.dart';

@JsonSerializable()
class Comment {
  String id;
  String body;
  User author;
  String post;
  Comment comment;
  DateTime time;
  Comment replies;
  int upvotes;
  int downvotes;

  Comment({
    @required this.id,
    @required this.body,
    @required this.author,
    @required this.post,
    this.comment,
    this.time,
    this.replies,
    this.upvotes,
    this.downvotes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
